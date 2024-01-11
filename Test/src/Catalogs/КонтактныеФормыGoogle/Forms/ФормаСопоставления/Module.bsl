
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаголовокПоляФормы = Параметры.Заголовок;
	ИндексПоля = Параметры.ИндексПоля;
	Элементы.ДекорацияТекст.Заголовок = СтрЗаменить(Элементы.ДекорацияТекст.Заголовок,"ФИО",ЗаголовокПоляФормы);
	
	Элементы.ПолеУНФ.СписокВыбора.Очистить();
	СписокСопоставлений = Новый СписокЗначений;
	Элементы.ПолеУНФ.СписокВыбора.Добавить(Перечисления.ТипыКонтактнойИнформации.ПустаяСсылка(), НСтр("ru = 'Нет'"),,);
	Элементы.ПолеУНФ.СписокВыбора.Добавить(Перечисления.ТипыКонтактнойИнформации.Телефон, НСтр("ru = 'Телефон'"));
	Элементы.ПолеУНФ.СписокВыбора.Добавить(Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты, НСтр("ru = 'E-mail'"));
	Элементы.ПолеУНФ.СписокВыбора.Добавить(Перечисления.ТипыКонтактнойИнформации.Skype, НСтр("ru = 'Skype'"));
	Элементы.ПолеУНФ.СписокВыбора.Добавить(Перечисления.ТипыКонтактнойИнформации.Другое, НСтр("ru = 'Мессенджер'"));
	
	ПолеУНФ = Параметры.ПолеПоискаУНФ;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	СтруктураЗакрытия = Новый Структура;
	СтруктураЗакрытия.Вставить("ПолеУНФ", ПолеУНФ);
	СтруктураЗакрытия.Вставить("ИндексПоля", ИндексПоля);
	Оповестить("СопоставлениеПолей", СтруктураЗакрытия);
КонецПроцедуры

#КонецОбласти