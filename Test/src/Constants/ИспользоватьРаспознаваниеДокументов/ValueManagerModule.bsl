#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегистрыСведений.ОбщиеНастройкиРаспознаваниеДокументов
		.УстановитьАвтоматическиУдалятьОбработанныеИПомеченныеНаУдаление(Значение);
	
	РаспознаваниеДокументовСлужебный.УстановитьПараметрРегламентногоЗадания(
		Метаданные.РегламентныеЗадания.ОбменССервисомРаспознаванияДокументов,
		"Использование",
		Значение
	);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли