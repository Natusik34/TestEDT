
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбработкаЗавершена = Ложь;
	
	НачатьТранзакцию();
	Попытка
		ДатаПоследнегоИзменения = ТекущаяДатаСеанса();
	
		ДвоичныеДанныеКэша = РегистрыСведений.ФорматыЭлектронныхДокументов.ПолучитьМакет("ФорматыЭлектронныхДокументов");
				
		ДанныеКэша = СервисНастроекЭДО.ОбработкаРезультатаКаталогФорматовЭД(ДвоичныеДанныеКэша);		

		Если ДанныеКэша <> Неопределено Тогда
			ЭлектронныеДокументыЭДО.ОбновитьФорматыЭлектронныхДокументов(ДанныеКэша, ДатаПоследнегоИзменения);
		КонецЕсли;
		
		ОбработкаЗавершена = Истина;
		
		ЗафиксироватьТранзакцию();		
	Исключение		
		ОтменитьТранзакцию();
		
		ТекстСообщения = НСтр("ru = 'Не удалось заполнить кеши форматов электронных документов по причине:'") + Символы.ПС 
			+ ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(
			ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,,, ТекстСообщения);
	КонецПопытки;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсиюНачальноеЗаполнение(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК ЕстьЗаписи
		|ИЗ
		|	РегистрСведений.ФорматыЭлектронныхДокументов КАК ФорматыЭлектронныхДокументов";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ

#КонецОбласти

#КонецОбласти

#КонецЕсли
