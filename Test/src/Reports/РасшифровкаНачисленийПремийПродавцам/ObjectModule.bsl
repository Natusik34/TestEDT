#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Задать настройки формы отчета.
//
// Параметры:
//  Форма		 - ФормаКлиентскогоПриложения	 - Форма отчета
//  КлючВарианта - Строка						 - Ключ загружаемого варианта
//  Настройки	 - Структура					 - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт

	Настройки.РазрешеноИзменятьВарианты = Истина;
	Настройки.РазрешеноИзменятьСтруктуру = Истина;
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// Процедура - Обработчик заполнения настроек отчета и варианта
//
// Параметры:
//  НастройкиОтчета		 - Структура - Настройки отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиОтчета 
//  НастройкиВариантов	 - Структура - Настройки варианта отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиВарианта
//
Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ОтчетыУНФ.ФормаОтчетаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеВариантаНаСервере
//
// Параметры:
//  Форма			 - ФормаКлиентскогоПриложения	 - Форма отчета
//  НовыеНастройкиКД - НастройкиКомпоновкиДанных	 - Загружаемые настройки КД
//
Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ОбновитьВидимостьОтбораОрганизация(Форма.Отчет.КомпоновщикНастроек);
	ОтчетыУНФ.ФормаОтчетаПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеПользовательскихНастроекНаСервере
//
// Параметры:
//  Форма							 - ФормаКлиентскогоПриложения				 - Форма отчета
//  НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных - Загружаемые пользовательские
//                                                                                 настройки КД
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПеренестиПараметрыЗаголовкаВНастройки(КомпоновщикНастроек.Настройки, НовыеПользовательскиеНастройкиКД);
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОтчетыУНФ.ОбъединитьСПользовательскимиНастройками(КомпоновщикНастроек); 
	
	НастройкиКомпоновки = КомпоновщикНастроек.Настройки;
	
	СтруктураПараметров = Новый Структура;
	
	Период = НастройкиКомпоновки.ПараметрыДанных.Элементы.Найти("Период");
	ДатаПолученияПравил = НастройкиКомпоновки.ПараметрыДанных.Элементы.Найти("ДатаПолученияПравил");
	Организация = НастройкиКомпоновки.ПараметрыДанных.Элементы.Найти("Организация");
	Сотрудник = НастройкиКомпоновки.ПараметрыДанных.Элементы.Найти("Сотрудник");
	
	СтруктураПараметров.Вставить("Организация", ?(Организация.Использование, Организация.Значение, Неопределено));
	СтруктураПараметров.Вставить("Сотрудник", ?(Сотрудник.Использование, Сотрудник.Значение, Неопределено));
	СтруктураПараметров.Вставить("НачалоПериода", Период.Значение.ДатаНачала);
	СтруктураПараметров.Вставить("КонецПериода", КонецДня(Период.Значение.ДатаОкончания));
	
	Если ЗначениеЗаполнено(ДатаПолученияПравил.Значение) Тогда
		
		СтруктураПараметров.Вставить("ДатаПолученияПравил", НачалоДня(ДатаПолученияПравил.Значение));
		
	Иначе
		
		СтруктураПараметров.Вставить("ДатаПолученияПравил", НачалоДня(СтруктураПараметров.КонецПериода));
		
	КонецЕсли;
	
	ТаблицаРассчитанныхПремий = ПолучитьТаблицуРассчитанныхПремий(СтруктураПараметров);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновки, ДанныеРасшифровки,,);
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТаблицаРассчитанныхПремий", ТаблицаРассчитанныхПремий);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	// АПК:216-выкл
	НастройкиВариантов["РасшифровкаНачисленийПремийПродавцам"].Теги = НСТР("ru = 'Расшифровка,Начисления,Продажи,Премия,Премии'");
	// АПК:216-вкл
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["РасшифровкаНачисленийПремийПродавцам"].СвязанныеПоля, "Продавец", "Справочник.Сотрудники");
	
КонецПроцедуры

Функция ПолучитьТаблицуРассчитанныхПремий(СтруктураПараметров)
	
	Возврат ЗарплатаИПерсоналСервер.РассчитатьТаблицуПремийПоЛичнымПродажам(СтруктураПараметров);
	
КонецФункции

#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли







