#Область СлужебныйПрограммныйИнтерфейс

Процедура ОтправитьДействиеВGA(Действие, Категория = "Поведение пользователя", ПараметрыПокупки = Неопределено, ЗавершениеРаботы = Ложь) Экспорт
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	СборСтатистикиМПКлиентСерверПереопределяемый.ОтправитьДействиеВGA(Действие, Категория, ПараметрыПокупки);
	
КонецПроцедуры

#КонецОбласти
