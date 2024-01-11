
#Область ПрограммныйИнтерфейс

// Возвращает признак использования каталога расширений
//
// Возвращаемое значение:
//  Булево
Функция Используется() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает наименование ссылки для перехода в каталог расширений
//
// Возвращаемое значение:
//  Строка
Функция НаименованиеСсылкиКаталогаРасширений() Экспорт
	
	Возврат НСтр("ru = 'Каталог расширений'");
	
КонецФункции

// Возвращает актульное состояние расширения
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//  ПубличныйИдентификатор - Строка - публичный идентификатор расширения из Менеджера сервиса
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СостоянияРасширений
Функция СостояниеРасширения(ПубличныйИдентификатор) Экспорт
КонецФункции


// Информация об оценке пользователя.
// 
// Параметры:
//  ПубличныйИдентификатор - Строка - публичный идентификатор расширения из Менеджера сервиса
// 
// Возвращаемое значение:
//  Структура - Информация об оценке пользователя:
// * ОценкаВыставлена - Булево - флаг того, что пользователь выставил оценку
// * НаименованиеРасширения - Строка - наименование расширения
// * Оценка - Число - числовое представление оценки
// * ДатаСоздания - Дата - дата создания первой оценки
// * ДатаПоследнегоИзменения - Дата - дата последнего изменения оценки
// * Версия - Строка - версия расширения которая была установлена в момент последнего редактирования оценки
// * ОтветРазработчика - Строка - текст ответа разработчика на оценку
// * ДатаОтветаРазработчика - Дата - дата ответа разработчика на оценку
// * ОшибкаПолученияДанных - Структура - если при получении данных произошла ошибка, тогда данное свойство существует:
// ** ТекстОшибки - Строка - текст информации об ошибке
Функция ИнформацияОбОценкеПользователя(ПубличныйИдентификатор) Экспорт
	
	ДанныеОшибки = Новый Структура();
	ДанныеОшибки.Вставить("ТекстОшибки", НСтр("ru = 'Расширение fresh не подключено.'"));
	
	ДанныеОтвета = Новый Структура();
	ДанныеОтвета.Вставить("ОценкаВыставлена", Ложь);
	ДанныеОтвета.Вставить("НаименованиеРасширения", "");
	ДанныеОтвета.Вставить("Оценка", 0);
	ДанныеОтвета.Вставить("ДатаСоздания", Дата(1, 1, 1));
	ДанныеОтвета.Вставить("ДатаПоследнегоИзменения", Дата(1, 1, 1));
	ДанныеОтвета.Вставить("Версия", "");
	ДанныеОтвета.Вставить("ОтветРазработчика", "");
	ДанныеОтвета.Вставить("ДатаОтветаРазработчика", Дата(1, 1, 1));
	ДанныеОтвета.Вставить("ОшибкаПолученияДанных", ДанныеОшибки);
	
	Возврат ДанныеОтвета;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
//	УстанавливаемыеРасширения - Массив Из Структура - со свойствами:
//		* Идентификатор - УникальныйИдентификатор - идентификатор расширения в сервисе.
//		* Представление - Строка - представление расширения. 
//		* Инсталляция - УникальныйИдентификатор - новый идентификатор инсталляции.
//		
// Возвращаемое значение:
// 	Булево - Истина, если успешно, Ложь - в противном случае.
//
Функция ВосстановитьРасширенияВНовойОбласти(Знач УстанавливаемыеРасширения, 
	Знач ИдентификаторПользователяСервиса = Неопределено) Экспорт
	
	Возврат Ложь;
	
КонецФункции

// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//  КодОбластиДанных - Число - 
//  
// Возвращаемое значение:
//	Структура - со свойствами:
//	 * КлючОбластиДанных - Строка - 
//	 * РасширенияДляВосстановления - см. ВосстановитьРасширенияВНовойОбласти.УстанавливаемыеРасширения
//
Функция ПолучитьРасширенияДляНовойОбласти(Знач КодОбластиДанных) Экспорт
КонецФункции

// Возвращаемое значение: 
//  Массив из Тип - ссылочные типы, добавляемые расширениями.
Функция СсылочныеТипыДобавляемыеРасширениями() Экспорт
	
	СсылочныеТипы = Новый Массив;
	ТипыОбъектовМетаданныхСсылочногоТипа = ТипыОбъектовМетаданныхСсылочногоТипа();
	
	ЭтоРазделенныйСеанс = РаботаВМоделиСервиса.ИспользованиеРазделителяСеанса();
	
	УстановитьПривилегированныйРежим(Истина);
	РасширенияСеанса = РасширенияКонфигурации.Получить(,
		ИсточникРасширенийКонфигурации.СеансАктивные);
	
	ОбластьДействияРазделение = ОбластьДействияРасширенияКонфигурации.РазделениеДанных;	
	Для Каждого Расширение Из РасширенияСеанса Цикл
		
		Если ЭтоРазделенныйСеанс И
			Расширение.ОбластьДействия <> ОбластьДействияРазделение Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ Расширение.ИзменяетСтруктуруДанных() Тогда
			Продолжить;
		КонецЕсли;
		
		ОМДРасширения = Новый ОбъектМетаданныхКонфигурация(Расширение.ПолучитьДанные());
		
		Для Каждого ТипОМД Из ТипыОбъектовМетаданныхСсылочногоТипа Цикл
			ДополнитьТипы(СсылочныеТипы, ТипОМД, ОМДРасширения);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат СсылочныеТипы;
	
КонецФункции

Процедура ЗаписатьДанныеВосстанавливаемыхРасширенийОбласти(РасширенияДляВосстановления) Экспорт 
	
	ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(
		"ДанныеРасширений", 
		РасширенияДляВосстановления, 
		"РасширенияДляВосстановления");
	
КонецПроцедуры

Процедура ПрочитатьДанныеВосстанавливаемыхРасширенийОбласти(ДанныеРасширений) Экспорт 

	Если ТипЗнч(ДанныеРасширений) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеРасширений.Свойство("РасширенияДляВосстановления") Тогда
		Возврат;
	КонецЕсли;	
	
	ДанныеХранилища = ПрочитатьДанныеВосстанавливаемыхРасширений();
		
	Если ДанныеХранилища <> Неопределено Тогда
		ДанныеРасширений.Вставить("РасширенияДляВосстановления", ДанныеХранилища);	
	КонецЕсли;
	
КонецПроцедуры

Функция ПрочитатьДанныеВосстанавливаемыхРасширений() Экспорт
	
	Возврат ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
		"ДанныеРасширений",
		"РасширенияДляВосстановления");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДополнитьТипы(СсылочныеТипы, ТипОМД, ОМДРасширения)
	
	ПринадлежностьОбъекта = Метаданные.СвойстваОбъектов.ПринадлежностьОбъекта.Собственный; 
	
	Для Каждого ОМД Из ОМДРасширения[ТипОМД] Цикл
		
		Если ОМД.ПринадлежностьОбъекта <> ПринадлежностьОбъекта Тогда
			Продолжить;
		КонецЕсли;
		
		СсылкаДляОпределенияТипа = ПредопределенноеЗначение(ОМД.ПолноеИмя() 
			+ ".ПустаяСсылка");
		СсылочныеТипы.Добавить(ТипЗнч(СсылкаДляОпределенияТипа));
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТипыОбъектовМетаданныхСсылочногоТипа()
	
	ТипыОбъектовМетаданныхСсылочногоТипа = Новый Массив;
	ТипыОбъектовМетаданныхСсылочногоТипа.Добавить("Справочники");
	ТипыОбъектовМетаданныхСсылочногоТипа.Добавить("Документы");
	ТипыОбъектовМетаданныхСсылочногоТипа.Добавить("БизнесПроцессы");
	ТипыОбъектовМетаданныхСсылочногоТипа.Добавить("Задачи");
	ТипыОбъектовМетаданныхСсылочногоТипа.Добавить("ПланыСчетов");
	ТипыОбъектовМетаданныхСсылочногоТипа.Добавить("ПланыОбмена");
	ТипыОбъектовМетаданныхСсылочногоТипа.Добавить("ПланыВидовХарактеристик");
	ТипыОбъектовМетаданныхСсылочногоТипа.Добавить("ПланыВидовРасчета");
	
	Возврат ТипыОбъектовМетаданныхСсылочногоТипа;
	
КонецФункции

#КонецОбласти