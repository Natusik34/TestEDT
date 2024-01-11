
&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииПослеПолученияКонтекстаЭДО", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодсказкаНетCSP3ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://infotecs.ru/");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодсказкаНетCSP5ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://www.cryptopro.ru/");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкачатьViPNet(Команда)
	 
	Оповещение = Новый ОписаниеОповещения("СкачатьViPNetПослеУстановки", ЭтотОбъект);
	ОбщегоНазначенияЭДКОКлиент.УстановитьViPNetCSP(Оповещение, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СкачатьCryptoPro(Команда)
	
	Оповещение = Новый ОписаниеОповещения("СкачатьCryptoProПослеУстановки", ЭтотОбъект);
	ОбщегоНазначенияЭДКОКлиент.УстановитьCryptoProCSP(Оповещение, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СкачатьViPNetПослеУстановки(Результат, ВходящийКонтекст) Экспорт
	
	Если НЕ Результат.Выполнено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось установить криптопровайдер.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкачатьCryptoProПослеУстановки(Результат, ВходящийКонтекст) Экспорт
	
	Если НЕ Результат.Выполнено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось установить криптопровайдер.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииПослеПолученияКонтекстаЭДО(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	ДлительнаяОтправкаКлиент.ЗакрытьФормуОжиданияЗагрузкиМодуля();
	
КонецПроцедуры

#КонецОбласти



