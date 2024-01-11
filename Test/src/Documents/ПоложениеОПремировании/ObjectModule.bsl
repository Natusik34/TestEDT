#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;	
		
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения, "");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
		
		МассивНепроверяемыхРеквизитов = Новый Массив;
		
		Если ВариантИспользованияПоложенияДляМагазина = 
			Перечисления.ВариантыИспользованияПоложенийДляРасчетаПремий.ОдноПоложениеДляВсехМагазинов Тогда
			
			МассивНепроверяемыхРеквизитов.Добавить("Магазины");
			
		КонецЕсли;
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	ТаблицаМагазины.Магазин КАК Магазин
		               |ПОМЕСТИТЬ ТаблицаРезультатМагазины
		               |ИЗ
		               |	&ТаблицаМагазины КАК ТаблицаМагазины
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ РАЗЛИЧНЫЕ
		               |	ТаблицаПравилаРасчетаПремий.ПравилоРасчетаПремий КАК ПравилоРасчетаПремий,
		               |	ТаблицаПравилаРасчетаПремий.Магазин КАК Магазин
		               |ПОМЕСТИТЬ ТаблицаРезультатПравилаРасчетаПремий
		               |ИЗ
		               |	&ТаблицаПравилаРасчетаПремий КАК ТаблицаПравилаРасчетаПремий
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	РезультатМагазины.Магазин КАК Магазин
		               |ИЗ
		               |	ТаблицаРезультатМагазины КАК РезультатМагазины
		               |;
		               |
		               |////////////////////////////////////////////////////////////////////////////////
		               |ВЫБРАТЬ
		               |	РезультатПравилаРасчетаПремий.ПравилоРасчетаПремий КАК ПравилоРасчетаПремий,
		               |	РезультатПравилаРасчетаПремий.Магазин КАК Магазин
		               |ИЗ
		               |	ТаблицаРезультатПравилаРасчетаПремий КАК РезультатПравилаРасчетаПремий";
		
		Запрос.УстановитьПараметр("ТаблицаМагазины", Магазины.Выгрузить());
		Запрос.УстановитьПараметр("ТаблицаПравилаРасчетаПремий", ПравилаРасчетаПремий.Выгрузить());
		Результат = Запрос.ВыполнитьПакет();
		
		Если НЕ Результат[2].Выгрузить().Количество() = Магазины.Количество() Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Дублируются строки в списке %1'"), НСтр("ru='Подразделения'"));
			Поле = НСтр("ru = 'Магазины'");
			ОбщегоНазначения.СообщитьПользователю(Текст, ЭтотОбъект, Поле,,	Отказ);
			
		ИначеЕсли НЕ Результат[3].Выгрузить().Количество() = ПравилаРасчетаПремий.Количество() Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Дублируются строки в списке %1'"), НСтр("ru='Правила расчета премий'"));	
			Поле = НСтр("ru = 'ПравилаРасчетаПремий'");
			ОбщегоНазначения.СообщитьПользователю(Текст, ЭтотОбъект, Поле,,	Отказ);
			
		КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументовУНФ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	Документы.ПоложениеОПремировании.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеДокументовУНФ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ОтразитьДействующиеПравила(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеДокументовУНФ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура ОтразитьДействующиеПравила (ДополнительныеСвойства, Движения, Отказ)
	
	Таблица= ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДействующихПравил;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Движения.ДействующиеПравилаРасчетаПремий.Записывать = Истина;
	Движения.ДействующиеПравилаРасчетаПремий.Загрузить(Таблица);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли