#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	ДанныеДляПроведения = ДанныеДляПроведенияДокумента();
	
	УчетНДФЛ.СформироватьУдержанныйНалогПоВременнойТаблице(Движения, Отказ, Организация, Дата, ДанныеДляПроведения.МенеджерВременныхТаблиц);
	Если Движения.РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	Для каждого Движение Из Движения.РасчетыНалогоплательщиковСБюджетомПоНДФЛ Цикл
		Движение.ВариантУдержания = Перечисления.ВариантыУдержанияНДФЛ.ВозвращеноНалоговымАгентом
	КонецЦикла;
	СформироватьВозвратПеречисленногоЗаСотрудника();
	
	УчетНДФЛ.СформироватьНДФЛКПеречислению(Движения, Отказ);
	ДанныеДляДополнения = ОтражениеЗарплатыВУчете.НовоеОписаниеПараметровДополненияНДФЛСтатьями();
	ДанныеДляДополнения.БазаРаспределения 	= ДанныеДляПроведения.УдержанияПоРабочимМестам;
	ДанныеДляДополнения.ПоляОтбора 			= "ФизическоеЛицо,НачислениеУдержание";
	ОтражениеЗарплатыВУчете.ДополнитьНДФЛКПеречислениюСведениямиОРаспределенииПоСтатьям(Движения, ДанныеДляДополнения);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.РасчетыСБюджетомПоНДФЛ") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетыСБюджетомПоНДФЛ");
		Модуль.РасчетыСБюджетомПоНДФЛЗарегистрироватьНДФЛКПеречислению(Движения, Отказ);
	КонецЕсли;
	
	УчетНачисленнойЗарплаты.ЗарегистрироватьВозвратНДФЛ(Движения, Отказ, Организация, Месяц, ДанныеДляПроведения.УдержанияПоРабочимМестам, ПорядокВыплаты());
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для Каждого СтрокаСотрудника Из СуммыВозврата Цикл
		Если СтрокаСотрудника.Налог  = 0 И СтрокаСотрудника.НалогСПревышения = 0 Тогда
			СообщениеОбОшибке = СтрШаблон(НСтр("ru='В строке №%1 не указаны суммы возврата налога.'"), СтрокаСотрудника.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(СообщениеОбОшибке,,,,Отказ);
		КонецЕсли;
	КонецЦикла;
	
	// Проверка корректности распределения по источникам финансирования
	ВозвратНДФЛВнутренний.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьВозвратПеречисленногоЗаСотрудника()
	
	ДатаОперации = КонецМесяца(Месяц);
	Возвраты = Движения.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Выгрузить();
	Возвраты.Свернуть("ФизическоеЛицо,Организация,Ставка,МесяцНалоговогоПериода,РегистрацияВНалоговомОргане,ВключатьВДекларациюПоНалогуНаПрибыль,ИсчисленоПоДивидендам,Период,РеквизитыПлатежногоПоручения,Сторно,КрайнийСрокУплаты", "Сумма");
	Возвраты.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15, 0)));
	НомерСтроки = 0;
	Для Каждого СтрокаРасчета Из Возвраты Цикл
		СтрокаРасчета.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Возвраты", Возвраты);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаОперации", ДатаОперации);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Возвраты.НомерСтроки КАК НомерСтроки,
	|	Возвраты.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Возвраты.Организация КАК Организация,
	|	Возвраты.Ставка КАК Ставка,
	|	Возвраты.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	|	Возвраты.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
	|	Возвраты.ВключатьВДекларациюПоНалогуНаПрибыль КАК ВключатьВДекларациюПоНалогуНаПрибыль,
	|	Возвраты.ИсчисленоПоДивидендам КАК ИсчисленоПоДивидендам,
	|	Возвраты.Сумма КАК Сумма
	|ПОМЕСТИТЬ ВТВозвраты
	|ИЗ
	|	&Возвраты КАК Возвраты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Возвраты.НомерСтроки КАК НомерСтроки,
	|	Возвраты.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Возвраты.Организация КАК Организация,
	|	Возвраты.Ставка КАК Ставка,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	|	Возвраты.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
	|	Возвраты.ВключатьВДекларациюПоНалогуНаПрибыль КАК ВключатьВДекларациюПоНалогуНаПрибыль,
	|	Возвраты.ИсчисленоПоДивидендам КАК ИсчисленоПоДивидендам,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Период КАК Период,
	|	-Возвраты.Сумма КАК СуммаКРаспределению,
	|	СУММА(РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Сумма) КАК Сумма,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.РеквизитыПлатежногоПоручения КАК РеквизитыПлатежногоПоручения,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Сторно КАК Сторно,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.КрайнийСрокУплаты КАК КрайнийСрокУплаты
	|ИЗ
	|	ВТВозвраты КАК Возвраты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ КАК РасчетыНалоговыхАгентовСБюджетомПоНДФЛ
	|		ПО (РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Период МЕЖДУ ДОБАВИТЬКДАТЕ(Возвраты.МесяцНалоговогоПериода, ГОД, -1) И &ДатаОперации)
	|			И Возвраты.ФизическоеЛицо = РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ФизическоеЛицо
	|			И Возвраты.Организация = РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Организация
	|			И Возвраты.Ставка = РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Ставка
	|			И (РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.МесяцНалоговогоПериода МЕЖДУ НАЧАЛОПЕРИОДА(Возвраты.МесяцНалоговогоПериода, ГОД) И Возвраты.МесяцНалоговогоПериода)
	|			И Возвраты.РегистрацияВНалоговомОргане = РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.РегистрацияВНалоговомОргане
	|			И Возвраты.ВключатьВДекларациюПоНалогуНаПрибыль = РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ВключатьВДекларациюПоНалогуНаПрибыль
	|			И Возвраты.ИсчисленоПоДивидендам = РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ИсчисленоПоДивидендам
	|ГДЕ
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|	И РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Регистратор <> &Ссылка
	|	И РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Сумма <> 0
	|
	|СГРУППИРОВАТЬ ПО
	|	Возвраты.НомерСтроки,
	|	Возвраты.ФизическоеЛицо,
	|	Возвраты.Организация,
	|	Возвраты.Ставка,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.МесяцНалоговогоПериода,
	|	Возвраты.РегистрацияВНалоговомОргане,
	|	Возвраты.ВключатьВДекларациюПоНалогуНаПрибыль,
	|	Возвраты.ИсчисленоПоДивидендам,
	|	Возвраты.Сумма,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.РеквизитыПлатежногоПоручения,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Сторно,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.Период,
	|	РасчетыНалоговыхАгентовСБюджетомПоНДФЛ.КрайнийСрокУплаты
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки,
	|	Период УБЫВ,
	|	РеквизитыПлатежногоПоручения УБЫВ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Возвраты.Очистить();
	Пока Выборка.СледующийПоЗначениюПоля("НомерСтроки") Цикл 
		СуммаКРаспределению = Выборка.СуммаКРаспределению;
		Пока Выборка.Следующий() Цикл 
			Если СуммаКРаспределению > 0 Тогда
				СписываемаяСумма = Мин(Выборка.Сумма, СуммаКРаспределению);
				СуммаКРаспределению = СуммаКРаспределению - СписываемаяСумма;
				СтрокаТаблицыРезультатов = Возвраты.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТаблицыРезультатов, Выборка);
				СтрокаТаблицыРезультатов.Сумма = -СписываемаяСумма;			
			КонецЕсли;
		КонецЦикла;			
	КонецЦикла;
	ЕстьНовыеСтроки = Ложь;
	Для каждого СтрокаТЗ Из Возвраты Цикл
		ЕстьНовыеСтроки = Истина;
		УчетНДФЛ.СтрокаПеречисленияНДФЛПоНалогоплательщику(Движения, Организация, ДатаОперации, СтрокаТЗ);
		НоваяСтрока = УчетНДФЛ.СтрокаУплатыНалоговогоАгента(Движения, Организация, ДатаОперации, ВидДвиженияНакопления.Расход, СтрокаТЗ);
		НоваяСтрока.ДатаПлатежа = СтрокаТЗ.Период;
	КонецЦикла;
	Если ЕстьНовыеСтроки Тогда
		Движения.УплатаНДФЛНалоговымиАгентамиКРаспределению.Записывать = Истина;
	КонецЕсли;
	
КонецПроцедуры

Функция ДанныеДляПроведенияДокумента()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВозвратНДФЛСуммыВозврата.Ссылка.Сотрудник КАК ФизическоеЛицо,
	|	ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка) КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.ВидыДоходовНДФЛ.ПустаяСсылка) КАК КодДохода,
	|	ВозвратНДФЛСуммыВозврата.МесяцНалоговогоПериода КАК Период,
	|	ВозвратНДФЛСуммыВозврата.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	|	ВозвратНДФЛСуммыВозврата.КатегорияДохода КАК КатегорияДохода,
	|	ВозвратНДФЛСуммыВозврата.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
	|	ВозвратНДФЛСуммыВозврата.СтавкаНалогообложенияРезидента КАК СтавкаНалогообложенияРезидента,
	|	-СУММА(ВозвратНДФЛСуммыВозврата.Налог) КАК Сумма,
	|	-СУММА(ВозвратНДФЛСуммыВозврата.НалогСПревышения) КАК СуммаСПревышения
	|ПОМЕСТИТЬ ВТНалогУдержанный
	|ИЗ
	|	Документ.ВозвратНДФЛ.СуммыВозврата КАК ВозвратНДФЛСуммыВозврата
	|ГДЕ
	|	ВозвратНДФЛСуммыВозврата.Ссылка = &Ссылка
	|	И (ВозвратНДФЛСуммыВозврата.Налог > 0
	|			ИЛИ ВозвратНДФЛСуммыВозврата.НалогСПревышения > 0)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВозвратНДФЛСуммыВозврата.Ссылка.Сотрудник,
	|	ВозвратНДФЛСуммыВозврата.МесяцНалоговогоПериода,
	|	ВозвратНДФЛСуммыВозврата.РегистрацияВНалоговомОргане,
	|	ВозвратНДФЛСуммыВозврата.Ссылка.Месяц,
	|	ВозвратНДФЛСуммыВозврата.КатегорияДохода,
	|	ВозвратНДФЛСуммыВозврата.СтавкаНалогообложенияРезидента,
	|	ВозвратНДФЛСуммыВозврата.МесяцНалоговогоПериода";
	Запрос.Выполнить();
	
	РеквизитыДляПроведения = Новый Структура("Ссылка,Организация,Сотрудник,ФизическоеЛицо,Месяц,Подразделение,ТерриторияВыполненияРаботВОрганизации");
	ЗаполнитьЗначенияСвойств(РеквизитыДляПроведения, ЭтотОбъект);
	РеквизитыДляПроведения.ФизическоеЛицо = Сотрудник;
	
	УдержанияПоРабочимМестам = ВозвратНДФЛВнутренний.УдержанияПоРабочимМестам(РеквизитыДляПроведения);
	
	Возврат Новый Структура("УдержанияПоРабочимМестам, МенеджерВременныхТаблиц", УдержанияПоРабочимМестам, Запрос.МенеджерВременныхТаблиц);

КонецФункции

Функция ПорядокВыплаты()
	
	Если Метаданные().Реквизиты.Найти("ПорядокВыплаты") = Неопределено Тогда
		Возврат Перечисления.ХарактерВыплатыЗарплаты.Зарплата
	Иначе	
		Возврат ЭтотОбъект["ПорядокВыплаты"]
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли