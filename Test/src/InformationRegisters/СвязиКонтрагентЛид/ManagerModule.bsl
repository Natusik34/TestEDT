#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура НоваяСвязь(Контрагент, Лид) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.СвязиКонтрагентЛид.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Лид = Лид;
	МенеджерЗаписи.Контрагент = Контрагент;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
