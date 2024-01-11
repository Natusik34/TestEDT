
// подмена формы по виду маркетплейса

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено( Объект.ВидМаркетплейса ) Тогда
		Если Параметры.Свойство( "ВидМаркетплейса" ) И ЗначениеЗаполнено( Параметры.ВидМаркетплейса ) Тогда
			Объект.ВидМаркетплейса = Параметры.ВидМаркетплейса;
		КонецЕсли;
	КонецЕсли;

	ВидМаркетплейса = Объект.ВидМаркетплейса;
    
	Если ВидМаркетплейса = ПредопределенноеЗначение( "Перечисление.ВидыМаркетплейсов.МаркетплейсOzon" ) Тогда
		ЭтаФорма.ОбработкаИмя = "МаркетплейсOzon";
	ИначеЕсли ВидМаркетплейса = ПредопределенноеЗначение( "Перечисление.ВидыМаркетплейсов.МаркетплейсЯндексМаркет" ) Тогда
		ЭтаФорма.ОбработкаИмя = "МаркетплейсЯндексМаркет";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Отказ = Истина;
	
	Если ЗначениеЗаполнено( ЭтаФорма.ОбработкаИмя ) Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить( "УчетнаяЗапись", Объект.Ссылка );
		ОткрытьФорму( "Обработка." + ОбработкаИмя + ".Форма.ФормаНастройки", ПараметрыФормы, , Объект.Ссылка );
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере( ТекущийОбъект, ПараметрыЗаписи )
	УправлениеДоступом.ПослеЗаписиНаСервере( ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи );
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере( ТекущийОбъект )
	УправлениеДоступом.ПриЧтенииНаСервере( ЭтотОбъект, ТекущийОбъект );
КонецПроцедуры
