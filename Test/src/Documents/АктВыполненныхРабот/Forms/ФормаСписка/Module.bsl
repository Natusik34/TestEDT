
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеОтмененногоЗаказа(
		СписокЗаказыПокупателей.КомпоновщикНастроек.Настройки.УсловноеОформление);
	
	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ПодменюПечать);
	ПечатьДокументовУНФ.КорректировкаРазмещениеПодчиненнойГруппыКомандПечати(ЭтаФорма, Элементы.ПодменюПечать,
		Элементы.ПодменюПечатьФаксимиле);
	НапоминанияПользователяУНФ.УстановитьОтображениеКомандОрганайзера(Элементы);
	ЭлектроннаяПочтаУНФ.УстановитьОтображениеКомандОтправкиСообщений(Элементы);
	
	// УНФ.ОтборыСписка
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект);
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
	ЗаполнитьСписокВыбораОтборОплата();
	ЗаполнитьСписокВыбораОтборСостояниеОригинала();
	// Конец УНФ.ОтборыСписка
	
	Если Элементы.ФильтрыНастройкиИДопИнфо.Видимость Тогда
		Элементы.ПраваяПанель.Ширина = 28;
	КонецЕсли;
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(СписокЗаказыПокупателей);
	
	// ИнтернетПоддержкаПользователей.Новости
	ОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
		ЭтотОбъект,
		"УНФ.Документ.АктВыполненныхРабот",
		"ФормаСписка",
		Неопределено,
		НСтр("ru='Новости: Акты выполненных работ'"),
		Ложь,
		Новый Структура("ПолучатьНовостиНаСервере, ХранитьМассивНовостейТолькоНаСервере", Истина, Истина),
		"ПриОткрытии");
	// Конец ИнтернетПоддержкаПользователей.Новости
	
	// ЭДО
	УправлениеНебольшойФирмойЭлектронныеДокументыСервер.КомандыЭДО_ФормаСписка(ЭтотОбъект);
	// Конец ЭДО
	
	// УНФ.ПанельКонтактнойИнформации
	КонтактнаяИнформацияПанельУНФ.ПриСозданииНаСервере(ЭтотОбъект, "КонтактнаяИнформация", "СписокКонтекстноеМеню");
	// Конец УНФ.ПанельКонтактнойИнформации
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументов.ПриСозданииНаСервере_ФормаСписка(ЭтотОбъект, Элементы.Список);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
	// ПодключаемоеОборудование
	ИспользоватьПодключаемоеОборудование = УправлениеНебольшойФирмойПовтИсп.ИспользоватьПодключаемоеОборудование();
	Если ИспользоватьПодключаемоеОборудование Тогда
		ТипыОборудования = МенеджерОборудованияКлиентСервер.ПараметрыТипыОборудования();
		ТипыОборудования.СканерШтрихкода = Истина;
		МенеджерОборудования.ПриСозданииНаСервере(ЭтотОбъект, ТипыОборудования);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Элементы.ФормаЗагрузитьСтатусыОплатыСБП.Видимость = ИнтеграцияСПлатежнымиСистемамиУНФ.ИнтеграцияДоступна();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	// Конец ИнтернетПоддержкаПользователей.Новости
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование 
	
	// ЭДО
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭДО
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли; 
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	РаботаСФормойКлиент.СписокДокументовОтгрузкиОбработкаОповещенияФрагмент(ЭтотОбъект, ИмяСобытия);
	
	Если ИмяСобытия = "Запись_АктВыполненныхРабот"
		И Элементы.Страницы.ТекущаяСтраница=Элементы.СтраницаЗаказыПокупателей Тогда
		Элементы.СписокЗаказыПокупателей.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_СостоянияЗаказовПокупателей" Тогда
		УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	КонецЕсли;
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУНФКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУНФКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// ЭДО
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	// Конец ЭДО
	
	// УНФ.ПанельКонтактнойИнформации
	Если КонтактнаяИнформацияПанельУНФКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьПанельКонтактнойИнформации();
	КонецЕсли;
	// Конец УНФ.ПанельКонтактнойИнформации
	
	// УНФ.Интеграция с Яндекс.Кассой
	ОнлайнОплатыУНФКлиент.ОбработкаОповещения_ФормаСписка(Элементы.Список, ИмяСобытия, Параметр, Источник);
	// Конец УНФ.Интеграция с Яндекс.Кассой
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументовКлиент.ОбработчикОповещенияФормаСписка(ИмяСобытия, ЭтотОбъект, Элементы.Список);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьАктВыполненныхРабот(Команда)
	
	Если Элементы.СписокЗаказыПокупателей.ТекущиеДанные = Неопределено Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'");
		ПоказатьПредупреждение(Неопределено,ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
	
	МассивЗаказов = Элементы.СписокЗаказыПокупателей.ВыделенныеСтроки;
	
	Если МассивЗаказов.Количество() = 1 Тогда
		
		ПараметрыОткрытия = Новый Структура("Основание", МассивЗаказов[0]);
		ОткрытьФорму("Документ.АктВыполненныхРабот.ФормаОбъекта", ПараметрыОткрытия);
		
	Иначе
		
		СтруктураДанных = ПроверитьКлючевыеРеквизитыЗаказов(МассивЗаказов);
		Если СтруктураДанных.СформироватьНесколькоЗаказов Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Заказы отличаются данными (%1) шапки документов.
											|Сформировать несколько актов выполненных работ?'"),
				СтруктураДанных.ПредставлениеДанных);
				
			ПоказатьВопрос(Новый ОписаниеОповещения("СоздатьАктВыполненныхРаботЗавершение", ЭтотОбъект,
				Новый Структура("МассивЗаказов", МассивЗаказов)), ТекстСообщения, РежимДиалогаВопрос.ДаНет, 0);
			
		Иначе
			
			СтруктураЗаполнения = Новый Структура;
			СтруктураЗаполнения.Вставить("МассивЗаказовПокупателей", МассивЗаказов);
			ОткрытьФорму("Документ.АктВыполненныхРабот.ФормаОбъекта", Новый Структура("Основание", СтруктураЗаполнения));
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьАктВыполненныхРаботЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	МассивЗаказов = ДополнительныеПараметры.МассивЗаказов;
	
	
	Ответ = Результат;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		МассивДокументовПродаж = СформироватьДокументыПродажИЗаписать(МассивЗаказов);
		Текст = НСтр("ru='Создание:'");
		Для каждого СтрокаДокументПродажи Из МассивДокументовПродаж Цикл
			
			ПоказатьОповещениеПользователя(Текст, ПолучитьНавигационнуюСсылку(СтрокаДокументПродажи),
				СтрокаДокументПродажи, БиблиотекаКартинок.Информация32);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(
	"Документ.АктВыполненныхРабот", Список.КомпоновщикНастроек.Настройки.Отбор.Элементы, Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	ТекШтрихкод = "";
	
	ОбработкаЗавершения = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект,
		Новый Структура("ТекШтрихкод", ТекШтрихкод));
	
	#Если МобильныйКлиент Тогда
	ОткрытьФорму("ОбщаяФорма.ФормаПоискаПоШтрихкоду", , , , , , ОбработкаЗавершения);
	#Иначе
	ПоказатьВводЗначения(ОбработкаЗавершения, ТекШтрихкод, НСтр("ru = 'Введите штрихкод'"));
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСтатусыОплатыСБП(Команда)
	
    ИнтеграцияСПлатежнымиСистемамиУНФКлиент.ЗагрузитьСтатусыОплатыИзФормыСписка(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументовКлиент.СписокВыбор(Поле.Имя, ЭтотОбъект, Элементы.Список, СтандартнаяОбработка);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	КонтактнаяИнформацияПанельУНФКлиент.ПриАктивизацииДинамическогоСписка(ЭтотОбъект, Элемент, ТекущийКонтрагент,
		"Контрагент");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументов.ПриПолученииДанныхНаСервере(Строки);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Ответственный", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ОтборОплатаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	Если ВыбранноеЗначение = "Без оплаты"
		Или ВыбранноеЗначение = "Оплачен частично"
		Или ВыбранноеЗначение = "Оплачен полностью" Тогда
		УстановитьМеткуИОтборСписка("СтатусОплаты", Элемент.Родитель.Имя, ВыбранноеЗначение);
	Иначе
		УстановитьМеткуИОтборСписка("НомерКартинкиОплаты", Элемент.Родитель.Имя, ВыбранноеЗначение);
	КонецЕсли;
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеОригиналаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = ПредопределенноеЗначение("Справочник.СостоянияОригиналовПервичныхДокументов.ПустаяСсылка") Тогда
		УстановитьМеткуИОтборСписка("СостояниеОригинала", Элемент.Родитель.Имя, ВыбранноеЗначение,
			УчетОригиналовПервичныхДокументовУНФКлиентСервер.СостояниеОригиналаНеизвестно());
	Иначе
		УстановитьМеткуИОтборСписка("СостояниеОригинала", Элемент.Родитель.Имя, ВыбранноеЗначение);
	КонецЕсли;
	
	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция проверяет отличие ключевых реквизитов.
//
&НаСервере
Функция ПроверитьКлючевыеРеквизитыЗаказов(МассивЗаказов)
	
	СтруктураДанных = Новый Структура();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Организация) КАК КоличествоОрганизация,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Контрагент) КАК КоличествоКонтрагент,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Договор) КАК КоличествоДоговор,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВидЦен) КАК КоличествоВидЦен,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВидСкидкиНаценки) КАК КоличествоВидСкидкиНаценки,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВалютаДокумента) КАК КоличествоВалютаДокумента,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.СуммаВключаетНДС) КАК КоличествоСуммаВключаетНДС,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.НДСВключатьВСтоимость) КАК КоличествоНДСВключатьВСтоимость,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.НалогообложениеНДС) КАК КоличествоНалогообложениеНДС
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателяШапка
	|ГДЕ
	|	ЗаказПокупателяШапка.Ссылка В(&МассивЗаказов)
	|
	|ИМЕЮЩИЕ
	|	(КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Организация) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Контрагент) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Договор) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВидЦен) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВидСкидкиНаценки) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВалютаДокумента) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.СуммаВключаетНДС) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.НДСВключатьВСтоимость) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.НалогообложениеНДС) > 1)";
	
	Запрос.УстановитьПараметр("МассивЗаказов", МассивЗаказов);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		СтруктураДанных.Вставить("СформироватьНесколькоЗаказов", Ложь);
		СтруктураДанных.Вставить("ПредставлениеДанных", "");
	Иначе
		СтруктураДанных.Вставить("СформироватьНесколькоЗаказов", Истина);
		ПредставлениеДанных = "";
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.КоличествоОрганизация > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Организация", ", Организация");
			КонецЕсли;
			
			Если Выборка.КоличествоКонтрагент > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Контрагент", ", Контрагент");
			КонецЕсли;
			
			Если Выборка.КоличествоДоговор > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Договор", ", Договор");
			КонецЕсли;
			
			Если Выборка.КоличествоВидЦен > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Вид цен", ", Вид цен");
			КонецЕсли;
			
			Если Выборка.КоличествоВидСкидкиНаценки > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Вид скидки", ", Вид скидки");
			КонецЕсли;
			
			Если Выборка.КоличествоВалютаДокумента > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Валюта", ", Валюта");
			КонецЕсли;
			
			Если Выборка.КоличествоСуммаВключаетНДС > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Сумма вкл. НДС", ", Сумма вкл. НДС");
			КонецЕсли;
			
			Если Выборка.КоличествоНДСВключатьВСтоимость > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "НДС вкл. в стоимость", ", НДС вкл. в стоимость");
			КонецЕсли;
			
			Если Выборка.КоличествоНалогообложениеНДС > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Налогообложение", ", Налогообложение");
			КонецЕсли;
			
		КонецЦикла;
		
		СтруктураДанных.Вставить("ПредставлениеДанных", ПредставлениеДанных);
		
	КонецЕсли;
	
	Возврат СтруктураДанных;
	
КонецФункции // ПроверитьКлючевыеРеквизитыЗаказов()

// Функция вызывает обработку заполнения документа по основанию.
//
&НаСервере
Функция СформироватьДокументыПродажИЗаписать(МассивЗаказов)
	
	МассивДокументовПродаж = Новый Массив();
	Для каждого СтрокаЗНП Из МассивЗаказов Цикл
		
		НовыйДокументПродажи = Документы.АктВыполненныхРабот.СоздатьДокумент();
		
		НовыйДокументПродажи.Дата = ТекущаяДатаСеанса();
		НовыйДокументПродажи.Заполнить(СтрокаЗНП);
		
		НовыйДокументПродажи.Записать();
		МассивДокументовПродаж.Добавить(НовыйДокументПродажи.Ссылка);
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
	Возврат МассивДокументовПродаж;
	
КонецФункции // СформироватьДокументыПродажИЗаписать()

&НаСервере
Процедура УстановитьУсловноеОформлениеПоЦветамСостоянийСервер()
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(
		СписокЗаказыПокупателей.КомпоновщикНастроек.Настройки.УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказовПокупателей.ПолноеИмя());
	
КонецПроцедуры

#Область ЗаполнениеСписковОтборов

&НаСервере
Процедура ЗаполнитьСписокВыбораОтборОплата()
	
	МассивИсключений = РаботаСОтборами.МассивИсключенийПоТипуДокумента("АктВыполненныхРабот");
	
	РаботаСОтборами.ЗаполнитьСписокВыбораОтборОплата(ЭтаФорма, "ОтборОплата", Ложь, МассивИсключений);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораОтборСостояниеОригинала()

	Элементы.ОтборСостояниеОригинала.СписокВыбора.Добавить(
		Справочники.СостоянияОригиналовПервичныхДокументов.ПустаяСсылка(),
		УчетОригиналовПервичныхДокументовУНФКлиентСервер.СостояниеОригиналаНеизвестно());

	Для Каждого ТекСостояние Из УчетОригиналовПервичныхДокументов.ИспользуемыеСостояния() Цикл
		Элементы.ОтборСостояниеОригинала.СписокВыбора.Добавить(ТекСостояние.Ссылка, ТекСостояние.Наименование);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение,
	ПредставлениеЗначения = "")

	Если ГруппаРодительМетки = "ГруппаОтборОплата" Тогда
		ПредставлениеЗначения = РаботаСОтборами.СформироватьПредставлениеМеткиОплата(ВыбранноеЗначение);
		Если ИмяПоляОтбораСписка = "НомерКартинкиОплаты" Тогда
			ВыбранноеЗначение = РаботаСОтборами.НомерКартинкиПоСтатусуОплаты(ВыбранноеЗначение);
		КонецЕсли;
	ИначеЕсли ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли;
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);

КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_") + 1);
	УдалитьМеткуОтбора(МеткаИД);

КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
	
	Если Элементы.ФильтрыНастройкиИДопИнфо.Видимость Тогда
		Элементы.ПраваяПанель.Ширина = 28;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтборы(Команда)
	
	ИмяРеквизитаСписка = "Список";
	ИмяТЧДанныеМеток = "ДанныеМеток";
	ИмяТЧДанныеОтборов = "ДанныеОтборов";
	ИмяГруппыОтборов = "ГруппаОтборы";
	ИмяПредопределенныеОтборыПоУмолчанию = "ПредопределенныеОтборыПоУмолчанию";
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяРеквизитаСписка", ИмяРеквизитаСписка);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеМеток", ИмяТЧДанныеМеток);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеОтборов", ИмяТЧДанныеОтборов);
	ДополнительныеПараметры.Вставить("ИмяГруппыОтборов", ИмяГруппыОтборов);
	ДополнительныеПараметры.Вставить("ИмяПредопределенныеОтборыПоУмолчанию", ИмяПредопределенныеОтборыПоУмолчанию);
	
	РаботаСОтборамиКлиент.НастроитьОтборыНажатие(ЭтотОбъект, ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры), ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры)
	
	Возврат РаботаСОтборами.ПараметрыДляОткрытияФормыСНастройкамиОтборов(ЭтотОбъект, ДополнительныеПараметры);
	
КонецФункции

&НаКлиенте
Процедура НастройкаОтборовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаОтборовЗавершениеНаСервере(Результат.АдресВыбранныеОтборы, Результат.АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура НастройкаОтборовЗавершениеНаСервере(АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры)
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ИмяРеквизитаСписка = "Список";
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	Иначе
		ИмяРеквизитаСписка = ДополнительныеПараметры.ИмяРеквизитаСписка;
		ИмяТЧДанныеМеток = ДополнительныеПараметры.ИмяТЧДанныеМеток;
		ИмяТЧДанныеОтборов = ДополнительныеПараметры.ИмяТЧДанныеОтборов;
	КонецЕсли;
	
	РаботаСОтборами.НастройкаОтборовЗавершение(ЭтотОбъект, АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОтборПриИзменении(Элемент)
	
	Подключаемый_ОтборПриИзмененииНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборПриИзмененииНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборПриИзменении(ЭтотОбъект, ЭлементИмя, ЭлементРодительИмя);
	
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОтборОчистка(Элемент)
	
	Подключаемый_ОтборОчисткаНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборОчисткаНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборОчистка(ЭтотОбъект, ЭлементИмя);

КонецПроцедуры

&НаКлиенте
Процедура СброситьВсеОтборы(Команда)
	РаботаСОтборамиКлиент.СброситьОтборПоПериоду(ЭтотОбъект, "Список", "Дата");
	СброситьВсеМеткиОтбораНаСервере();
КонецПроцедуры

&НаСервере
Процедура СброситьВсеМеткиОтбораНаСервере()
	РаботаСОтборами.УдалитьМеткиОтбораСервер(ЭтотОбъект, Список);
КонецПроцедуры

#КонецОбласти

#Область ПанельКонтактнойИнформации

// УНФ.ПанельКонтактнойИнформации
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбработатьАктивизациюСтрокиСписка()
	
	ОбновитьПанельКонтактнойИнформации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПанельКонтактнойИнформации()
	
	ДанныеПанелиКИ = ДанныеПанелиКонтактнойИнформации(ТекущийКонтрагент);
	КонтактнаяИнформацияПанельУНФКлиент.ЗаполнитьДанныеПанелиКИ(ЭтотОбъект, ДанныеПанелиКИ);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеПанелиКонтактнойИнформации(Контрагент)
	
	Возврат КонтактнаяИнформацияПанельУНФ.ДанныеПанелиКонтактнойИнформации(Контрагент);
	
КонецФункции

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока,
		Поле, СтандартнаяОбработка);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(Элемент)
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(ЭтотОбъект, Элемент);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыполнитьКоманду(Команда)
	КонтактнаяИнформацияПанельУНФКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, ТекущийКонтрагент);
КонецПроцедуры
// Конец УНФ.ПанельКонтактнойИнформации

#КонецОбласти

#Область ЗамерыПроизводительности

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	ОценкаПроизводительностиКлиент.ЗамерВремени("СозданиеФормы"
		+ РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	ОценкаПроизводительностиКлиент.ЗамерВремени("ОткрытиеФормы"
		+ РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
КонецПроцедуры

#КонецОбласти

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(Результат, Параметры) Экспорт

	Если Результат = Неопределено Тогда
		ТекШтрихкод = СокрЛП(Параметры.ТекШтрихкод);
	Иначе
		ТекШтрихкод = СокрЛП(Результат);
	КонецЕсли;
		
	Если ПустаяСтрока(ТекШтрихкод) Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Новый Структура;
	Данные.Вставить("Штрихкод", ТекШтрихкод);
	Данные.Вставить("Количество", 1);
	
	ОбработатьШтрихкоды(Данные);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если ЗначениеЗаполнено(МассивСсылок)  Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив;
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.АктВыполненныхРабот.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиБиблиотек

// ИнтернетПоддержкаПользователей.Новости
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтотОбъект, "ПриОткрытии");
КонецПроцедуры
// Конец ИнтернетПоддержкаПользователей.Новости

// ЭДО
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
КонецПроцедуры
// Конец ЭДО

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКомандыСостоянияОригинала()
	ОбновитьКомандыСостоянияОригинала();
КонецПроцедуры

&НаСервере
Процедура ОбновитьКомандыСостоянияОригинала()
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
КонецПроцедуры
//Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

#КонецОбласти

#КонецОбласти
