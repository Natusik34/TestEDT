
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("УчетнаяЗапись") Тогда
		УстановитьОтборПоУчетнойЗаписи(Параметры.УчетнаяЗапись);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборПоУчетнойЗаписи(УчетнаяЗапись)
	
	Элементы.УчетнаяЗапись.Видимость = Ложь;
	Заголовок = СтрШаблон(
	НСтр("ru = 'Ошибки по учетной записи ""%1""'"),
	УчетнаяЗапись);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
	Список,
	"УчетнаяЗапись",
	УчетнаяЗапись);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле = Элементы.Инструкция Тогда
		СтандартнаяОбработка = Ложь;
		РаботаСПочтовымиСообщениямиКлиент.СообщитьОбОшибкеПодключения(Элементы.Список.ТекущиеДанные.УчетнаяЗапись, 
		НСтр("ru = 'Ошибки при подключении учетной записи'"), 
		Элементы.Список.ТекущиеДанные.ПодробноеПредставлениеОшибки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти