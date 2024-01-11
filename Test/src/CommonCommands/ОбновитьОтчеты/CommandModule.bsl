
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОбновитьОтчетыСервер();
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Отчеты обновлены.'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьОтчетыСервер()
	
	ВариантыОтчетов.Обновить();
	ОтчетыУНФ.Обновить();
	ОтчетыУНФ.ОбновитьТегиОтчетов();
	
КонецПроцедуры

#КонецОбласти