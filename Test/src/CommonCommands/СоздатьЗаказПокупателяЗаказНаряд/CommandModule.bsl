
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура("Основание", ПараметрКоманды);
	ОткрытьФорму("Документ.ЗаказПокупателя.Форма.ФормаЗаказНаряда", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник);
	
КонецПроцедуры

#КонецОбласти 

