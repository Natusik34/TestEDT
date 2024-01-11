

#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмеющиеДоступ = Новый ФиксированныйМассив(Параметры.ИмеющиеДоступ);
	УправлениеФормойПриСозданииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПояснениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МультирежимКлиент.ПоказатьЗначения(ИмеющиеДоступ, НСтр("ru = 'Перечень пользователей:'"));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормойПриСозданииНаСервере()
	
	Ссылка = Новый ФорматированнаяСтрока(НСтр("ru = 'пользователей'"),,,,"пользователей");
	
	ДокументооборотСКОКлиентСервер.ЗаменитьСтрокуНаСсылку(
		Элементы.Пояснение.Заголовок, 
		НСтр("ru = 'пользователей'"), 
		Ссылка);
	
КонецПроцедуры	

#КонецОбласти




