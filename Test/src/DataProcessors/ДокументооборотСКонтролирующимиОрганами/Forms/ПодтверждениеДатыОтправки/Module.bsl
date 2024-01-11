
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметры.Сообщение) Тогда
		Отказ = Истина;
		Возврат;
	Иначе 
		Сообщение = Параметры.Сообщение;
	КонецЕсли;
	
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	// извлекаем файл подтверждения даты отправки из содержимого сообщения
	ТипыДИВ = Новый Массив;
	ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПодтверждениеДатыОтправки);
	ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПодтверждениеДатыОтправкиПредставление);
	СтрПодтверждения = КонтекстЭДО.ПолучитьВложенияТранспортногоСообщения(Сообщение, Истина, ТипыДИВ, ИмяФайлаПодтверждения);

	Если СтрПодтверждения.Количество() = 0 Тогда
		ТекстПредупреждения = "Подтверждение даты отправки не обнаружено среди содержимого сообщения.";
		Возврат;
	КонецЕсли;
	СтрПодтверждение = СтрПодтверждения[0];
	
	// записываем вложение во временный файл
	ФайлПодтверждения = ПолучитьИмяВременногоФайла("xml");
	Попытка
		СтрПодтверждение.Данные.Получить().Записать(ФайлПодтверждения);
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка выгрузки подтверждения даты отправки во временный файл:
                  |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецПопытки;
	
	// считываем подтверждение из файла в дерево XML
	ОписаниеОшибки = "";
	ДеревоXML = КонтекстЭДО.ЗагрузитьXMLВДеревоЗначений(ФайлПодтверждения, , ОписаниеОшибки);
	ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ФайлПодтверждения);
	Если НЕ ЗначениеЗаполнено(ДеревоXML) Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка чтения XML из файла подтверждения даты отправки:
                  |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	
	УзелФайл = ДеревоXML.Строки.Найти("Файл", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелФайл) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML подтверждения: не обнаружен узел ""Файл"".'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	УзелДокумент = УзелФайл.Строки.Найти("Документ", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелДокумент) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML подтверждения: не обнаружен узел ""Документ"".'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	УзелОргПодт = УзелДокумент.Строки.Найти("ОргПодт", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелОргПодт) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML подтверждения: не обнаружен узел ""ОргПодт"".'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	// получаем сведения об организации, подтвердившей дату отправки
	УзелСпецОперат = УзелОргПодт.Строки.Найти("СпецОперат", "Имя");
	УзелНО = УзелОргПодт.Строки.Найти("НО", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелСпецОперат) И НЕ ЗначениеЗаполнено(УзелНО) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML подтверждения: отсутствуют сведения об организации, подтвердившей дату отправки.'"),,,, Отказ);
		Возврат;
	ИначеЕсли ЗначениеЗаполнено(УзелСпецОперат) Тогда
		УзелНаимОрг = УзелСпецОперат.Строки.Найти("НаимОрг", "Имя");
		Если НЕ ЗначениеЗаполнено(УзелНаимОрг) Тогда
			ОбщегоНазначения.СообщитьПользователю(
				НСтр("ru = 'Некорректная структура XML подтверждения: отсутствуют сведения об организации, подтвердившей дату отправки.'"),,,, Отказ);
			Возврат;
		КонецЕсли;
		ОрганизацияСтр = СокрЛП(УзелНаимОрг.Значение);
	ИначеЕсли ЗначениеЗаполнено(УзелНО) Тогда
		УзелКодНО = УзелНО.Строки.Найти("КодНО", "Имя");
		УзелНаимНО = УзелНО.Строки.Найти("НаимНО", "Имя");
		Если ЗначениеЗаполнено(УзелКодНО) И ЗначениеЗаполнено(УзелКодНО.Значение) Тогда
			ОрганизацияСтр = СокрЛП(УзелКодНО.Значение);
			Если ЗначениеЗаполнено(УзелНаимНО) И ЗначениеЗаполнено(УзелНаимНО.Значение) Тогда
				ОрганизацияСтр = ОрганизацияСтр + " (" + СокрЛП(УзелНаимНО.Значение) + ")";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// получаем сведения подтверждения
	УзелСведПодтв = УзелДокумент.Строки.Найти("СведПодтв", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелСведПодтв) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML подтверждения: отсутствуют сведения подтверждения.'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	// получаем сведения об имени поступившего файла
	УзлыИмяПостФайла = УзелСведПодтв.Строки.НайтиСтроки(Новый Структура("Имя", "ИмяПостФайла"), Истина);
	Если ЗначениеЗаполнено(УзлыИмяПостФайла) Тогда
		ИменаПоступившихФайлов = Новый Массив;
		Для Каждого УзелИмяПостФайла Из УзлыИмяПостФайла Цикл
			ИменаПоступившихФайлов.Добавить(СокрЛП(УзелИмяПостФайла.Значение));
		КонецЦикла;
		
		ИмяПоступившегоФайла = СтрСоединить(ИменаПоступившихФайлов, ", ");
	КонецЕсли;
	
	// получаем сведения о дате и времени поступившего файла
	УзелДатаОтпр = УзелСведПодтв.Строки.Найти("ДатаОтпр", "Имя");
	УзелВремяОтпр = УзелСведПодтв.Строки.Найти("ВремяОтпр", "Имя");
	Если ЗначениеЗаполнено(УзелДатаОтпр) Тогда
		ДатаОтправки = СокрЛП(УзелДатаОтпр.Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(УзелВремяОтпр) Тогда
		Время = СокрЛП(УзелВремяОтпр.Значение);
		Время = СтрЗаменить(Время, ".", ":");
		ДатаОтправки = СокрЛП(ДатаОтправки + " " + Время);
	КонецЕсли;
	
	Элементы.Печать.Видимость = Параметры.ПечатьВозможна;
	Если Параметры.ПечатьВозможна Тогда
		ЦиклОбмена = Параметры.ЦиклОбмена;
		ФорматДокументооборота = Параметры.ЦиклОбмена.ФорматДокументооборота;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда 
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеВводаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПечатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	РезультатНастройки = Новый Структура("ПечататьПодтверждениеДатыОтправки, ФорматДокументооборота", Истина, ФорматДокументооборота);
	КонтекстЭДОКлиент.СформироватьИПоказатьПечатныеДокументы(ЦиклОбмена, РезультатНастройки);
	
КонецПроцедуры

#КонецОбласти