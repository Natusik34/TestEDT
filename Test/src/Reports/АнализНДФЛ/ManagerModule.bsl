#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
		
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализНДФЛПоМесяцам");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	НастройкиВарианта.Описание =
		НСтр("ru = '(Упрощенный) Налогооблагаемая сумма, примененные вычеты, сопоставление исчисленного, 
		|удержанного и перечисленного налогов по месяцам налогового периода.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализУплатыНДФЛ");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	НастройкиВарианта.Описание =
		НСтр("ru = 'Удержанный и уплаченный НДФЛ. Не актуален с 2016 г.
		|При уплате НДФЛ одновременно с выплатой зарплаты 
		|задолженность не образуется.'");
	НастройкиВарианта.Размещение.Очистить();
	НастройкиВарианта.Размещение.Вставить(Метаданные.Подсистемы.ЗарплатаКадрыПодсистемы.Подсистемы.УчетНДФЛ, "СмТакже");
		
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СводнаяСправка");
	НастройкиВарианта.ВидимостьПоУмолчанию = Ложь;
	НастройкиВарианта.Описание =
		НСтр("ru = '(Упрощенный) Краткая информация, отображаемая в справках 2-НДФЛ.'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли