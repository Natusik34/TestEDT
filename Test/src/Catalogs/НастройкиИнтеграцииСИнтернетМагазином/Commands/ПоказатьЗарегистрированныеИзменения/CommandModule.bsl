#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("НастройкаИнтеграции", ПараметрКоманды);
	
	ОткрытьФорму("Справочник.НастройкиИнтеграцииСИнтернетМагазином.Форма.ФормаИнформацияОЗарегистрированныхИзменениях",
	ПараметрыФормы,
	ПараметрыВыполненияКоманды.Источник,
	ПараметрыВыполненияКоманды.Уникальность,
	ПараметрыВыполненияКоманды.Окно,
	ПараметрыВыполненияКоманды.НавигационнаяСсылка
	);
	
КонецПроцедуры

#КонецОбласти
