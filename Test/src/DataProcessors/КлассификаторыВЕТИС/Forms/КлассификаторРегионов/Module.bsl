
&НаКлиенте
Процедура РегионыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Выбрать(Неопределено);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	GUIDСтраны = Параметры.GUIDСтраны;
	
	ЗагрузитьСписок(Неопределено, 1);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	ТекущиеДанные = Элементы.Регионы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Новый Структура;
	Данные.Вставить("Активность",    ТекущиеДанные.Активность);
	Данные.Вставить("Актуальность",  ТекущиеДанные.Актуальность);
	Данные.Вставить("GUID",          ТекущиеДанные.GUID);
	Данные.Вставить("UUID",          ТекущиеДанные.UUID);
	Данные.Вставить("Статус",        ТекущиеДанные.Статус);
	Данные.Вставить("Наименование",        ТекущиеДанные.Наименование);
	Данные.Вставить("НаименованиеПолное",  ТекущиеДанные.НаименованиеПолное);
	Данные.Вставить("ДатаСоздания",  ТекущиеДанные.ДатаСоздания);
	Данные.Вставить("ДатаИзменения", ТекущиеДанные.ДатаИзменения);
	
	Закрыть(Данные);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСписок(ПараметрыПоиска, НомерСтраницы)
	
	Результат = ИкарВЕТИСВызовСервера.СписокРегионовСтраны(GUIDСтраны, НомерСтраницы);
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Регионы.Очистить();
	Для Каждого СтрокаТЧ Из Результат.Список Цикл
		
		НоваяСтрока = Регионы.Добавить();
		НоваяСтрока.Активность    = СтрокаТЧ.active;
		НоваяСтрока.Актуальность  = СтрокаТЧ.last;
		НоваяСтрока.GUID          = СтрокаТЧ.GUID;
		НоваяСтрока.UUID          = СтрокаТЧ.UUID;
		НоваяСтрока.Наименование  = СтрокаТЧ.Name;
		НоваяСтрока.ДатаСоздания  = СтрокаТЧ.createDate;
		НоваяСтрока.ДатаИзменения = СтрокаТЧ.updateDate;
		
		НоваяСтрока.Статус = ИнтеграцияВЕТИСПовтИсп.СтатусВерсионногоОбъекта(СтрокаТЧ.status);
		
		НоваяСтрока.Код                = СтрокаТЧ.regionCode;
		НоваяСтрока.Тип                = СтрокаТЧ.type;
		НоваяСтрока.НаименованиеПолное = СтрокаТЧ.view;
		
	КонецЦикла;
	
	РегионыОбщееКоличество = Результат.ОбщееКоличество;
	РегионыНомерСтраницы   = НомерСтраницы;
	РегионыПараметрыПоиска = ПараметрыПоиска;
	
	КоличествоСтраниц = РегионыОбщееКоличество / ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	Если Цел(КоличествоСтраниц) <> КоличествоСтраниц Тогда
		КоличествоСтраниц = Цел(КоличествоСтраниц) + 1;
	КонецЕсли;
	Если КоличествоСтраниц = 0 Тогда
		КоличествоСтраниц = 1;
	КонецЕсли;
	
	Команды["НавигацияСтраницаТекущаяСтраница"].Заголовок =
		СтрШаблон(
			НСтр("ru = 'Страница %1 из %2'"),
			РегионыНомерСтраницы, КоличествоСтраниц);
	
	Элементы.СтраницаСледующая.Доступность  = (РегионыНомерСтраницы < КоличествоСтраниц);
	Элементы.СтраницаПредыдущая.Доступность = (РегионыНомерСтраницы > 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПервая(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьСписок(РегионыПараметрыПоиска, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПоследняя(Команда)
	
	ОчиститьСообщения();
	
	КоличествоСтраниц = РегионыОбщееКоличество / ИнтеграцияВЕТИСКлиентСервер.РазмерСтраницы();
	Если Цел(КоличествоСтраниц) <> КоличествоСтраниц Тогда
		КоличествоСтраниц = Цел(КоличествоСтраниц) + 1;
	КонецЕсли;
	Если КоличествоСтраниц = 0 Тогда
		КоличествоСтраниц = 1;
	КонецЕсли;
	
	ЗагрузитьСписок(РегионыПараметрыПоиска, КоличествоСтраниц);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаПредыдущая(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьСписок(РегионыПараметрыПоиска, РегионыНомерСтраницы - 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаСледующая(Команда)
	
	ОчиститьСообщения();
	
	ЗагрузитьСписок(РегионыПараметрыПоиска, РегионыНомерСтраницы + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура НавигацияСтраницаТекущаяСтраница(Команда)
	
	ОчиститьСообщения();
	
КонецПроцедуры
