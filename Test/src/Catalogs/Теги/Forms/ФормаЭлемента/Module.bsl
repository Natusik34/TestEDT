
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрОповещения = Новый Структура;
	ПараметрОповещения.Вставить("Тег", Объект.Ссылка);
	ПараметрОповещения.Вставить("Наименование", Объект.Наименование);
	
	Оповестить("Запись_Теги", ПараметрОповещения, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти
