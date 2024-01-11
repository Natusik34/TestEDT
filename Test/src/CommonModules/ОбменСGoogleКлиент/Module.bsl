
#Область ПрограммныйИнтерфейс

// Открывает диалог настройки расписания
//
// Параметры:
//  ОбластьДоступа - ПеречислениеСсылка.ОбластиДоступаGoogle - область, для которой настраивается расписание.
//
Процедура ОткрытьДиалогНастройкиРасписания(ОбластьДоступа) Экспорт
	
	РасписаниеРегламентногоЗадания = ОбменСGoogleВызовСервера.РасписаниеРегламентногоЗадания(ОбластьДоступа);
	
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьИзменениеРасписания", ЭтотОбъект, ОбластьДоступа);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьИзменениеРасписания(Расписание, ОбластьДоступа) Экспорт
	
	Если Расписание <> Неопределено Тогда
		ОбменСGoogleВызовСервера.УстановитьРасписаниеРегламентногоЗадания(Расписание, ОбластьДоступа);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
