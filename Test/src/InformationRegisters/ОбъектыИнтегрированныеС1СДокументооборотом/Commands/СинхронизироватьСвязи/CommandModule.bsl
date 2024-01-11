#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СинхронизацияСвязейЗавершение", ЭтотОбъект, ПараметрыВыполненияКоманды);
	
	ОткрытьФорму(
		"РегистрСведений.ОбъектыИнтегрированныеС1СДокументооборотом.Форма.СинхронизацияСвязей",,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СинхронизацияСвязейЗавершение(ЛишниеСвязи, ПараметрыВыполненияКоманды) Экспорт
	
	Если ТипЗнч(ЛишниеСвязи) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму(
		"РегистрСведений.ОбъектыИнтегрированныеС1СДокументооборотом.Форма.ЛишниеСвязи",
		ЛишниеСвязи,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти