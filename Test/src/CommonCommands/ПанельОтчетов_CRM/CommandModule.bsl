#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПутьКПодсистеме = "CRM";
	ФормаПараметры = Новый Структура("ПутьКПодсистеме", ПутьКПодсистеме);
	
	ФормаОкно = ?(ПараметрыВыполненияКоманды = Неопределено, Неопределено, ПараметрыВыполненияКоманды.Окно);
	ФормаСсылка = ?(ПараметрыВыполненияКоманды = Неопределено, Неопределено, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	ИдентификаторЗамера = ОценкаПроизводительностиКлиент.ЗамерВремени("ПанельОтчетов.Открытие", , Ложь);
	Комментарий = Новый Соответствие;
	Комментарий.Вставить("ПутьКПодсистеме", ПутьКПодсистеме);
	ОценкаПроизводительностиКлиент.УстановитьКомментарийЗамера(ИдентификаторЗамера, Комментарий);
	
	ОткрытьФорму("ОбщаяФорма.ФормаСпискаОтчетов", ФормаПараметры, , ПутьКПодсистеме, ФормаОкно, ФормаСсылка);
	
	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(ИдентификаторЗамера);
	
КонецПроцедуры

#КонецОбласти
