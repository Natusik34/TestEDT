
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ВладелецФайлов", ВладелецФайлов);
	Параметры.Свойство("Номенклатура", Номенклатура);
	Параметры.Свойство("ХарактеристикаНоменклатуры", ХарактеристикаНоменклатуры);
	
	Если Не ЗначениеЗаполнено( Номенклатура ) 
	И ТипЗнч( ВладелецФайлов ) = Тип( "СправочникСсылка.Номенклатура" ) Тогда
		Номенклатура = ВладелецФайлов;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено( ХарактеристикаНоменклатуры ) 
	И ТипЗнч( ВладелецФайлов ) = Тип( "СправочникСсылка.ХарактеристикиНоменклатуры" ) Тогда
		ХарактеристикаНоменклатуры = ВладелецФайлов;
		Номенклатура = ОбщегоНазначения.ЗначениеРеквизитаОбъекта( ХарактеристикаНоменклатуры, "Владелец" );
	КонецЕсли;
	
	ЭтаФорма.Элементы.ТаблицаФайловВладелец.Видимость = ЗначениеЗаполнено( ХарактеристикаНоменклатуры );
	ЭтаФорма.Элементы.ХарактеристикаНоменклатуры.Видимость = ЗначениеЗаполнено( ХарактеристикаНоменклатуры );
	
	ОбновитьТаблицуФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецФайловПриИзменении(Элемент)
	
		ОбновитьТаблицуФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(,Элементы.ТаблицаФайлов.ТекущиеДанные.Файл);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИзменения()
	РезультатЗаписи = ЗаписатьИзмененияНаСервере();
	Если РезультатЗаписи = Истина Тогда
		ОповеститьФормыОЗаписи();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзмененияИЗакрыть()

	ЗаписатьИзменения();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВсе(Команда)
	УстановитьСнятьПометкуНаКлиенте(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкиВсе(Команда)
	УстановитьСнятьПометкуНаКлиенте(Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗаписатьИзмененияНаСервере()
	
	РезультатЗаписи = ИнтеграцияСМаркетплейсамиСервер.СоставИСортировкаФайловДляСайтаЗаписать( ТаблицаФайлов );
	ЭтаФорма.Модифицированность = Не РезультатЗаписи;
	
	Возврат РезультатЗаписи;
КонецФункции

&НаКлиенте
Функция ОповеститьФормыОЗаписи()
	ПараметрыЗаписи = Новый Структура( "Номенклатура, ХарактеристикаНоменклатуры", Номенклатура, ХарактеристикаНоменклатуры );
	Оповестить( "РегистрСведений.СортировкаФайловДляСайта.Запись", ПараметрыЗаписи, ЭтаФорма.ИмяФормы );
	
	Возврат Истина;
КонецФункции

&НаСервере
Процедура ОбновитьТаблицуФайлов()
	ПараметрыКонтекст = Новый Структура( "Номенклатура", Номенклатура );
	Изображения = ИнтеграцияСМаркетплейсамиСервер.НоменклатураИзображенияПолучить( ВладелецФайлов, Истина, ПараметрыКонтекст );
	
	ТаблицаФайлов.Загрузить(Изображения);
	Для Каждого Стр Из ТаблицаФайлов Цикл
		Стр.Картинка = ИнтеграцияСМаркетплейсамиСервер.ПрисоединенныйФайлВоВременноеХранилище(Стр.Файл, ЭтаФорма.УникальныйИдентификатор);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСнятьПометкуНаКлиенте(Пометка)
	Для Каждого Стр Из ТаблицаФайлов Цикл
		Стр.ВыгружатьНаСайт = Пометка;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловДобавитьФайлСДиска(Команда)
	РаботаСФайламиСлужебныйКлиент.ДобавитьФайлИзФайловойСистемы(ЭтаФорма.ВладелецФайлов, ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_Файл" Тогда
		Если ТипЗнч( Параметр ) = Тип( "Структура" ) Тогда
			Если Параметр.Свойство( "Файл" ) И Параметр.Свойство( "ЭтоНовый" ) И Параметр.ЭтоНовый = Истина Тогда
				Если Параметр.Свойство( "ВладелецФайла" ) И Параметр.ВладелецФайла = ЭтаФорма.ВладелецФайлов Тогда
					
					ПрисоединенныйФайл = Параметр.Файл;
					КонтекстПараметры = Новый Структура;
					ЭтоИзображение = ИнтеграцияСМаркетплейсомOzonВызовСервера.ПрисоединенныйФайлЭтоИзображение( ПрисоединенныйФайл, КонтекстПараметры );
					Если Не ЭтоИзображение Тогда
						Возврат;
					КонецЕсли;
					
					// добавлен новый присоединенный файл
                    ТаблицаФайловДобавитьСтроку(Параметр);
                    ЭтаФорма.Элементы.ТаблицаФайлов.Обновить();

					ЭтаФорма.Модифицированность = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловДобавитьСтроку(Параметр)
	
	ТаблицаФайловСтрока = ТаблицаФайлов.Добавить();
	ТаблицаФайловСтрока.Файл = Параметр.Файл;
	ТаблицаФайловСтрока.ВыгружатьНаСайт = Истина;
	ТаблицаФайловСтрока.Сортировка = ТаблицаФайлов[ ТаблицаФайлов.Количество() - 1 ].Сортировка + 1;
	ТаблицаФайловСтрока.ВладелецФайлов = Параметр.ВладелецФайла;
	ТаблицаФайловСтрока.Владелец = Параметр.ВладелецФайла;
	ТаблицаФайловСтрока.Картинка = ИнтеграцияСМаркетплейсамиВызовСервера.ПрисоединенныйФайлВоВременноеХранилище( ТаблицаФайловСтрока.Файл, ЭтаФорма.УникальныйИдентификатор );
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловОбновить(Команда)
	ОбновитьТаблицуФайлов();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаФайловПриИзменении(Элемент)
	ЭтаФорма.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ТипЗнч( ЭтаФорма.ВладелецФормы ) = Тип( "ФормаКлиентскогоПриложения" ) Тогда
		ВладелецФормаИмя = ЭтаФорма.ВладелецФормы.ИмяФормы;
		Если Найти( ВладелецФормаИмя, "Справочник.Номенклатура" ) > 0 Тогда
			ЭтаФорма.Элементы.Номенклатура.Видимость = Ложь;
			ЭтаФорма.Элементы.ХарактеристикаНоменклатуры.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти