#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПриЗаписи(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	УчетПособийСоциальногоСтрахования.ПриЗаписиРегистраГражданствоФизическихЛиц(ЭтотОбъект, Отказ, Замещение);
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
