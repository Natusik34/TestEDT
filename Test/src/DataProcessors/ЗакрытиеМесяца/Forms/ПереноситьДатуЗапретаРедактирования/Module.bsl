#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Да(Команда)

	Если БольшеНеСпрашивать Тогда
		УстановитьБольшеНеСпрашивать(Истина);
	КонецЕсли;

	Закрыть(КодВозвратаДиалога.Да);

КонецПроцедуры

&НаКлиенте
Процедура Нет(Команда)

	Если БольшеНеСпрашивать Тогда
		УстановитьБольшеНеСпрашивать(Ложь);
	КонецЕсли;

	Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьБольшеНеСпрашивать(ВариантУстановкиДаНет)

	Если ВариантУстановкиДаНет Тогда
		Константы.ПереноситьДатуЗапретаРедактирования.Установить(Перечисления.ДаНет.Да);
	Иначе
		Константы.ПереноситьДатуЗапретаРедактирования.Установить(Перечисления.ДаНет.Нет);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
