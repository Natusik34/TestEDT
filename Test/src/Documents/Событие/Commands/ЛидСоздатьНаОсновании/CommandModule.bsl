
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ТекСтрокаПолучатели = ПараметрыВыполненияКоманды.Источник.Элементы.Получатели.ТекущиеДанные;
	
	Если ТекСтрокаПолучатели = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ МожноСоздатьЛид(ТекСтрокаПолучатели.Контакт, ПараметрыВыполненияКоманды.Источник) Тогда
		Возврат;
	КонецЕсли;
	
	КИКонтактнойФормы = ПодготовитьКонтактнуюИнформациюПоДаннымКФ(ПараметрКоманды, ТекСтрокаПолучатели.КакСвязаться);
	Если КИКонтактнойФормы <> Неопределено Тогда
		ПараметрыФормы = ПараметрыФормыПоКФ(ПараметрКоманды, КИКонтактнойФормы, ТекСтрокаПолучатели.Контакт);
		ОткрытьФорму("Справочник.Лиды.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник.Элементы.Получатели);
		Возврат;
	КонецЕсли;
		
	Если Не ЭлектроннаяПочтаУНФКлиент.АдресЭлектроннойПочтыЗаполнен(ПараметрыВыполненияКоманды.Источник, ТекСтрокаПолучатели.КакСвязаться) Тогда
		Возврат;
	КонецЕсли;

	ИсточникПривлечения = ПолучитьЗначениеИсточникаПривлечения(ПараметрКоманды);
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура);
	ПараметрыФормы.ЗначенияЗаполнения.Вставить("ИсточникПривлечения", ИсточникПривлечения);
	
	ПараметрыФормы.Вставить("КонтактКакСвязаться", Новый Структура);
	ПараметрыФормы.КонтактКакСвязаться.Вставить("Контакт", ТекСтрокаПолучатели.Контакт);
	ПараметрыФормы.КонтактКакСвязаться.Вставить("КакСвязаться", ТекСтрокаПолучатели.КакСвязаться);
	ПараметрыФормы.КонтактКакСвязаться.Вставить("ТипКИ", ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты"));
	
	ОткрытьФорму("Справочник.Лиды.ФормаОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник.Элементы.Получатели);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПараметрыФормыПоКФ(ПараметрКоманды, КИКонтактнойФормы, Контакт)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("Контакт", Контакт);
	ИсточникПривлечения = ПолучитьЗначениеИсточникаПривлечения(ПараметрКоманды);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура);
	ПараметрыФормы.ЗначенияЗаполнения.Вставить("ИсточникПривлечения", ИсточникПривлечения);
	ПараметрыФормы.Вставить("ДанныеИзКонтактнойФормы", КИКонтактнойФормы);
	Возврат ПараметрыФормы;
КонецФункции

&НаСервере
Функция ПодготовитьКонтактнуюИнформациюПоДаннымКФ(Событие, КакСвязаться)
	Возврат Справочники.КонтактныеФормыGoogle.ПодготовитьКонтактнуюИнформациюПоДаннымКФ(Событие, КакСвязаться);
КонецФункции

&НаКлиенте
Функция МожноСоздатьЛид(Контакт, Форма) Экспорт
	
	МожноСоздатьЛид = Истина;
	
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.КонтактныеЛица") Тогда
		МожноСоздатьЛид = Ложь;
		ТекстСообщения = НСтр("ru='Контакт уже создан.'");
	КонецЕсли;
	
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Контрагенты") Тогда
		МожноСоздатьЛид = Ложь;
		ТекстСообщения = НСтр("ru='Контрагент уже создан.'");
	КонецЕсли;
	
	Если ТипЗнч(Контакт) = Тип("СправочникСсылка.Лиды") Тогда
		МожноСоздатьЛид = Ложь;
		ТекстСообщения = НСтр("ru='Лид уже создан.'");
	КонецЕсли;
	
	Если НЕ МожноСоздатьЛид Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			ТекстСообщения,,
			СтрШаблон(
				"Объект.Участники[%1].Контакт", 
				Формат(Форма.Объект.Участники.Индекс(Форма.Элементы.Получатели.ТекущиеДанные), "ЧГ=")
			));
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПолучитьЗначениеИсточникаПривлечения(Событие)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Событие, "ИсточникПривлечения");
	
КонецФункции

#КонецОбласти
