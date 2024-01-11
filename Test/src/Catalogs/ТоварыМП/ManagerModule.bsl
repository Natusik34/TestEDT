#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Или МобильноеПриложениеСервер Тогда

#КонецЕсли

#Область ПрограммныйИнтерфейс

Функция ЕстьЭлементыПоОтбору(ОтборПоГруппе = Неопределено, ОтборПоНаименованию = "", ОтбиратьГруппы = Ложь) Экспорт
	
	Если ЗначениеЗаполнено(ОтборПоГруппе) Тогда
		ВыборкаСправочника = Справочники.ТоварыМП.Выбрать(ОтборПоГруппе);
	Иначе
		ВыборкаСправочника = Справочники.ТоварыМП.Выбрать();
	КонецЕсли;
	
	Пока ВыборкаСправочника.Следующий() Цикл
		Если НЕ ВыборкаСправочника.ПометкаУдаления
			И ВыборкаСправочника.ЭтоГруппа = ОтбиратьГруппы
			И (ПустаяСтрока(ОтборПоНаименованию) ИЛИ Найти(НРег(ВыборкаСправочника.Наименование), НРег(ОтборПоНаименованию)) > 0) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ПолучитьКартинкуССервера(Товар, СообщениеОбОшибке = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СоединениеСЦБУстановлено = ОбщегоНазначенияМПВызовСервера.ПолучитьЗначениеКонстанты("СинхронизацияВключенаМП");
	Если НЕ СоединениеСЦБУстановлено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Попытка
		
		// АПК:488-выкл методы безопасного запуска обеспечиваются этой функцией
		МодульСинхронизацияЗапросыКЦентральномуУзлу = Вычислить("СинхронизацияЗапросыКЦентральномуУзлу");
		// АПК:488-вкл
		Если ТипЗнч(МодульСинхронизацияЗапросыКЦентральномуУзлу) = Тип("ОбщийМодуль") Тогда
			
			ДанныеОтвета = МодульСинхронизацияЗапросыКЦентральномуУзлу.ПолучитьКартинкуССервера(Строка(Товар.Ссылка.УникальныйИдентификатор()));
			Если НЕ ЗначениеЗаполнено(ДанныеОтвета) Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;

		
	Исключение
		Инфо = ИнформацияОбОшибке();
		СообщениеОбОшибке = НСтр("ru='Для загрузки необходимо обновить серверную информационную базу. Минимально необходимая версия - 1.6.9.26.';en='You need to update the back-end database. The minimum required version is 1.6.9.26.'");
		// Сбор статистики
		ПолноеОписание = ПодробноеПредставлениеОшибки(Инфо);
		СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьОшибкуВGA(ПолноеОписание);
		// Конец сбор статистики
		Возврат Неопределено;
	КонецПопытки;
	
	АдресФотоВоВременномХранилище = ПоместитьВоВременноеХранилище(ДанныеОтвета);
	
	Возврат АдресФотоВоВременномХранилище;
	
КонецФункции

// Возвращает ставку налога
//
// Параметры:
//  Товар - СправочникСсылка.ТоварыМП
// 
// Возвращаемое значение:
//  Число - ставка налога
//
Функция ПолучитьСтавкуНалога(Товар) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ТоварыМП.СтавкаНДС.Ставка, 0) КАК СтавкаНДССтавка,
	|	ТоварыМП.СтавкаНалога КАК СтавкаНалога
	|ИЗ
	|	Справочник.ТоварыМП КАК ТоварыМП
	|ГДЕ
	|	ТоварыМП.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Товар);
	
	ВыборкаЗапроса = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаЗапроса.Следующий() Тогда
		Если ИспользуетсяНовыйВариантУказанияСтавкиНалога() Тогда
			Возврат ВыборкаЗапроса.СтавкаНалога;
		Иначе
			Возврат ВыборкаЗапроса.СтавкаНДССтавка;
		КонецЕсли;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

// Возвращает вариант указания ставки налога
//
// Возвращаемое значение:
//  Булево - вариант указания ставки. Истина - новый. Ложь - старый.
//
Функция ИспользуетсяНовыйВариантУказанияСтавкиНалога() Экспорт
	
	Возврат НСтр("en = 'en'; ru = 'ru'") = "en";
	
КонецФункции

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#КонецЕсли
