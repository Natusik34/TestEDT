
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Неопределено;
	Параметры.Свойство("Данные", Данные);
	РазделительНомераСтроки = "___";
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатентаРекомендованнаяФорма;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	ЭтотОбъект.ИмяМакетаАрхиваТабличныхДокументов = "ЭкранныеФормы1720";
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2017_1");
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		УведомлениеОСпецрежимахНалогообложения.ЗагрузитьДанныеПростогоУведомления(ЭтотОбъект, Данные, ПредставлениеУведомления)
	ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Организация = Параметры.Ключ.Организация;
		ЗагрузитьДанные(Параметры.Ключ);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Организация = Параметры.ЗначениеКопирования.Организация;
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	Иначе
		Параметры.Свойство("Организация", Объект.Организация);
		Если Не ЗначениеЗаполнено(Объект.Организация) Тогда 
			Отказ = Истина; Возврат;
		КонецЕсли;
		Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		ЗаполнитьНачальныеДанные();
	КонецЕсли;
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	Заголовок = Заголовок + " (" + Объект.Организация + ")";
	ИдДляСвор = УведомлениеОСпецрежимахНалогообложения.ПолучитьИдентификаторыДляСворачивания(ЭтотОбъект);
	СворачиваемыеЭлементы = ПоместитьВоВременноеХранилище(ИдДляСвор);
	РучнойВвод = Ложь;
	
	Для Каждого Элт Из ДанныеМногостраничныхРазделов.Форма2017_1_ЛистА Цикл 
		ЛистА = Элт.Значение;
		Если ТипЗнч(ЛистА) <> Тип("Структура") Или ЛистА.Свойство("АдресXML") Тогда 
			Прервать;
		КонецЕсли;
		
		ЛистА.Вставить("АдресXML", "");
		ЛистА.Вставить("Адрес9зпт", "");
	КонецЦикла;
	Для Каждого Элт Из ДанныеМногостраничныхРазделов.Форма2017_1_ЛистВ Цикл 
		ЛистВ = Элт.Значение;
		Если ТипЗнч(ЛистВ) <> Тип("Структура") Или ЛистВ.Свойство("АдресXML") Тогда 
			Прервать;
		КонецЕсли;
		
		ЛистВ.Вставить("АдресXML", "");
		ЛистВ.Вставить("Адрес9зпт", "");
	КонецЦикла;
	
	Если Не ДанныеУведомления.Форма2017_1_Титульная.Свойство("АдресXML") Тогда 
		ДанныеУведомления.Форма2017_1_Титульная.Вставить("АдресXML", "");
		ДанныеУведомления.Форма2017_1_Титульная.Вставить("Адрес9зпт", "");
	КонецЕсли;
	
	Если Не ДанныеУведомления.Форма2017_1_Лист2.Свойство("ВыводитьНольНаПечать") Тогда 
		ДанныеУведомления.Форма2017_1_Лист2.Вставить("ВыводитьНольНаПечать", Ложь);
	КонецЕсли;
	УведомлениеОСпецрежимахНалогообложения.СпрятатьКнопкиВыгрузкиОтправкиУНеактуальныхФорм(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтотОбъект, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Очистить(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОчиститьУведомление(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОчисткаОтчета() Экспорт
	УведомлениеОСпецрежимахНалогообложения.ОчисткаОтчетаДействия(Новый Структура("Форма", ЭтотОбъект));
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачальныеДанные() Экспорт
	ДанныеУведомленияТитульный = ДанныеУведомления["Форма2017_1_Титульная"];
	ДанныеУведомленияТитульный.Вставить("КодНО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код"));
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ДанныеУведомленияТитульный.Вставить("ДатаДок", Объект.ДатаПодписи);
	
	СтрокаСведений = "ИННФЛ,ФИО,ТелДом,ФамилияИП,ИмяИП,ОтчествоИП,ОГРН";
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
	ДанныеУведомленияТитульный.Вставить("ИННШапка", СведенияОбОрганизации.ИННФЛ);
	ДанныеУведомленияТитульный.Вставить("Фамилия", СведенияОбОрганизации.ФамилияИП);
	ДанныеУведомленияТитульный.Вставить("Имя", СведенияОбОрганизации.ИмяИП);
	ДанныеУведомленияТитульный.Вставить("Отчество", СведенияОбОрганизации.ОтчествоИП);
	ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелДом);
	ДанныеУведомленияТитульный.Вставить("ОГРН", СведенияОбОрганизации.ОГРН);
	
	Реквизиты = РегистрацияВНОСервер.ДанныеРегистрации(Объект.РегистрацияВИФНС);
	ДанныеУведомленияТитульный.Вставить("КодНО", Реквизиты.Код);
	
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ДанныеУведомленияТитульный.Вставить("ПрПодп", "2");
		ДанныеУведомленияТитульный.Вставить("НаимДок", Реквизиты.ДокументПредставителя);
	Иначе
		УстановитьПредставителяПоОрганизации();
		ДанныеУведомленияТитульный.Вставить("ПрПодп", "1");
		ДанныеУведомленияТитульный.Вставить("НаимДок", "");
	КонецЕсли;
	
	ЗаполнитьАдрес();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАдрес()
	Попытка
		ИндивидуальныйПредприниматель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Организация, "ИндивидуальныйПредприниматель");
		ДанныеУведомленияТитульный = ДанныеУведомления["Форма2017_1_Титульная"];
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	КонтактнаяИнформация.ЗначенияПолей
			|ИЗ
			|	Справочник.ФизическиеЛица.КонтактнаяИнформация КАК КонтактнаяИнформация
			|ГДЕ
			|	КонтактнаяИнформация.Ссылка = &Ссылка
			|	И КонтактнаяИнформация.Вид = &Вид";
		Запрос.УстановитьПараметр("Ссылка", ИндивидуальныйПредприниматель);
		Запрос.УстановитьПараметр("Вид", Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			АдресСтруктурой = РаботаСАдресами.СведенияОбАдресе(Выборка.ЗначенияПолей);
			ЗаполнитьЗначенияСвойств(ДанныеУведомленияТитульный, АдресСтруктурой);
			
			ДанныеУведомленияТитульный.КодРегион = АдресСтруктурой.КодРегиона;
			ДанныеУведомленияТитульный.НаселПункт = АдресСтруктурой.НаселенныйПункт;
			ДанныеУведомленияТитульный.Вставить("АдресXML", Выборка.ЗначенияПолей);
			ДанныеУведомленияТитульный.Вставить("Адрес9зпт", "");
			
			Если ТипЗнч(АдресСтруктурой.Помещения) = Тип("Массив")
				И АдресСтруктурой.Помещения.Количество() >= 1
				И АдресСтруктурой.Помещения[0].Свойство("Номер") Тогда 
				ДанныеУведомленияТитульный.Кварт = АдресСтруктурой.Помещения[0].Номер;
			ИначеЕсли ТипЗнч(АдресСтруктурой.Помещения) = Тип("Структура")
				И АдресСтруктурой.Помещения.Свойство("Номер") Тогда
				ДанныеУведомленияТитульный.Кварт = АдресСтруктурой.Помещения.Номер;
			КонецЕсли;
			
			Если ТипЗнч(АдресСтруктурой.Здание) = Тип("Массив")
				И АдресСтруктурой.Здание.Количество() >= 1
				И АдресСтруктурой.Здание[0].Свойство("Номер") Тогда 
				ДанныеУведомленияТитульный.Дом = АдресСтруктурой.Здание[0].Номер;
			ИначеЕсли ТипЗнч(АдресСтруктурой.Здание) = Тип("Структура")
				И АдресСтруктурой.Здание.Свойство("Номер") Тогда
				ДанныеУведомленияТитульный.Дом = АдресСтруктурой.Здание.Номер;
			КонецЕсли;
			
			Если ТипЗнч(АдресСтруктурой.Корпуса) = Тип("Массив")
				И АдресСтруктурой.Корпуса.Количество() >= 1
				И АдресСтруктурой.Корпуса[0].Свойство("Номер") Тогда 
				ДанныеУведомленияТитульный.Корпус = АдресСтруктурой.Корпуса[0].Номер;
			ИначеЕсли ТипЗнч(АдресСтруктурой.Корпуса) = Тип("Структура")
				И АдресСтруктурой.Корпуса.Свойство("Номер") Тогда
				ДанныеУведомленияТитульный.Корпус = АдресСтруктурой.Корпуса.Номер;
			КонецЕсли;
		КонецЕсли;
	Исключение
		ЗаписьЖурналаРегистрации("Ошибка получения контактной информации", УровеньЖурналаРегистрации.Предупреждение);
		Возврат;
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраниц() Экспорт
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	КорневойУровень = ДеревоСтраниц.ПолучитьЭлементы();
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Титульная страница";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Форма2017_1_Титульная";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Форма2017_1_Титульная";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Лист 2";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Форма2017_1_Лист2";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Форма2017_1_Лист2";
	
	СтрРег = КорневойУровень.Добавить();
	СтрРег.Наименование = "Листы А";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	
	СтрРег = СтрРег.ПолучитьЭлементы().Добавить();
	СтрРег.Наименование = "Стр. 1";
	СтрРег.ИндексКартинки = 1;
	СтрРег.ИмяМакета = "Форма2017_1_ЛистА";
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Ложь;
	СтрРег.УИД = Новый УникальныйИдентификатор;
	СтрРег.ИДНаименования = "Форма2017_1_ЛистА";
	
	СтрРег = КорневойУровень.Добавить();
	СтрРег.Наименование = "Листы Б";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	
	СтрРег = СтрРег.ПолучитьЭлементы().Добавить();
	СтрРег.Наименование = "Стр. 1";
	СтрРег.ИндексКартинки = 1;
	СтрРег.ИмяМакета = "Форма2017_1_ЛистБ";
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Ложь;
	СтрРег.УИД = Новый УникальныйИдентификатор;
	СтрРег.ИДНаименования = "Форма2017_1_ЛистБ";
	
	СтрРег = КорневойУровень.Добавить();
	СтрРег.Наименование = "Листы В";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	
	СтрРег = СтрРег.ПолучитьЭлементы().Добавить();
	СтрРег.Наименование = "Стр. 1";
	СтрРег.ИндексКартинки = 1;
	СтрРег.ИмяМакета = "Форма2017_1_ЛистВ";
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Ложь;
	СтрРег.УИД = Новый УникальныйИдентификатор;
	СтрРег.ИДНаименования = "Форма2017_1_ЛистВ";
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтроки(Элемент)
	Если УведомлениеОСпецрежимахНалогообложенияКлиент.НеобходимоФормированиеТабличногоДокумента(ЭтотОбъект, Элемент, ЭтотОбъект["УИДПереключение"]) Тогда
		ОтключитьОбработчикОжидания("ДеревоСтраницПриАктивизацииСтрокиЗавершение");
		ПодключитьОбработчикОжидания("ДеревоСтраницПриАктивизацииСтрокиЗавершение", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтрокиЗавершение() Экспорт 
	ПредУИД = ЭтотОбъект["УИДПереключение"];
	Элемент = Элементы.ДеревоСтраниц;
	
	Если Элемент.ТекущиеДанные.Многостраничность Тогда 
		ИмяМакета = УведомлениеОСпецрежимахНалогообложенияКлиент.ПолучитьИмяВыводимогоМакета(Элемент.ТекущиеДанные);
		ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, ПолучитьМногострочныеЧасти(Элемент.ТекущиеДанные), ПредУИД);
	Иначе 
		ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета, Элемент.ТекущиеДанные.МногострочныеЧасти, ПредУИД);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьМногострочныеЧасти(ТекущиеДанные)
	Если ТекущиеДанные.МногострочныеЧасти.Количество() > 0 Тогда 
		Возврат ТекущиеДанные.МногострочныеЧасти;
	ИначеЕсли ТекущиеДанные.ПолучитьЭлементы().Количество() > 0 Тогда 
		Возврат ТекущиеДанные.ПолучитьЭлементы()[0].МногострочныеЧасти;
	Иначе
		Возврат ТекущиеДанные.МногострочныеЧасти;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, МногострочныеЧасти, ПредУИД)
	Если Не УдалениеСтраницы И ТекущиеМногострочныеЧасти.Количество() > 0 Тогда 
		УведомлениеОСпецрежимахНалогообложения.СобратьДанныеМногострочныхЧастейТекущейСтраницы(
					ЭтотОбъект, ТекущиеМногострочныеЧасти, ПредУИД);
	КонецЕсли;
	
	ТекущиеМногострочныеЧасти = ОбщегоНазначения.СкопироватьРекурсивно(МногострочныеЧасти);
	ТекущийМакет = ИмяМакета;
	Макет = УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюМногостраничнуюСтраницу(ЭтотОбъект, ИмяМакета);
	УведомлениеОСпецрежимахНалогообложения.ПоказатьМногострочныеЧасти(ЭтотОбъект, Макет, МногострочныеЧасти);
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета, МногострочныеЧасти, ПредУИД)
	Если Не УдалениеСтраницы И ТекущиеМногострочныеЧасти.Количество() > 0 Тогда 
		УведомлениеОСпецрежимахНалогообложения.СобратьДанныеМногострочныхЧастейТекущейСтраницы(
					ЭтотОбъект, ТекущиеМногострочныеЧасти, ПредУИД);
	КонецЕсли;
	
	ТекущиеМногострочныеЧасти = ОбщегоНазначения.СкопироватьРекурсивно(МногострочныеЧасти);
	ТекущийМакет = ИмяМакета;
	Макет = УведомлениеОСпецрежимахНалогообложения.ПолучитьМакетТабличногоДокумента(ЭтотОбъект, ИмяМакета);
	УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюСтраницу(ЭтотОбъект, ИмяМакета, ПредУИД);
	УведомлениеОСпецрежимахНалогообложения.ПоказатьМногострочныеЧасти(ЭтотОбъект, Макет, МногострочныеЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
	
	Если Область.Имя = "ДатаДок" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
	
	Если (Область.Имя = "КодРегион"
		Или Область.Имя = "КодНОУчет")
		И ДанныеМногостраничныхРазделов.Свойство(ТекущееИДНаименования)
		И (Не РучнойВвод) Тогда
		
		О1 = ПредставлениеУведомления.Области["КодРегион"];
		О2 = ПредставлениеУведомления.Области["КодНОУчет"];
		
		ТекстСообщения = "";
		Для Каждого Стр Из ДанныеМногостраничныхРазделов[ТекущееИДНаименования] Цикл 
			Если Стр.Значение.УИД <> УИДТекущаяСтраница
				И (Стр.Значение[О1.Имя] <> О1.Значение Или Стр.Значение[О2.Имя] <> О2.Значение) Тогда 
				
				ТекстСообщения = НСтр("ru='Код региона и код налогового изменены на всех экземплярах страниц'");
			КонецЕсли;
			Стр.Значение[О1.Имя] = О1.Значение;
			Стр.Значение[О2.Имя] = О2.Значение;
		КонецЦикла;
		Если ЗначениеЗаполнено(ТекстСообщения) Тогда 
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	Реквизиты = РегистрацияВНОСервер.ДанныеРегистрации(Объект.РегистрацияВИФНС);
	ПредставлениеУведомления.Области["КодНО"].Значение = Реквизиты.Код;
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ПредставлениеУведомления.Области["ПрПодп"].Значение = "2";
		ПредставлениеУведомления.Области["НаимДок"].Значение = Реквизиты.ДокументПредставителя;
	Иначе
		УстановитьПредставителяПоОрганизации();
		ПредставлениеУведомления.Области["ПрПодп"].Значение = "1";
		ПредставлениеУведомления.Области["НаимДок"].Значение = "";
	КонецЕсли;
	
	ДанныеУведомленияТитульный = ДанныеУведомления["Форма2017_1_Титульная"];
	ДанныеУведомленияТитульный.Вставить("ПрПодп", ПредставлениеУведомления.Области["ПрПодп"].Значение);
	ДанныеУведомленияТитульный.Вставить("НаимДок", ПредставлениеУведомления.Области["НаимДок"].Значение);
	ДанныеУведомленияТитульный.Вставить("КодНО", ПредставлениеУведомления.Области["КодНО"].Значение);
	ДанныеУведомленияТитульный.Вставить("ДатаДок", ПредставлениеУведомления.Области["ДатаДок"].Значение);
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоФизЛицу(Физлицо)
	ДанныеУведомленияТитульный = ДанныеУведомления["Форма2017_1_Титульная"];
	Если ЗначениеЗаполнено(Физлицо) Тогда 
		ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(Физлицо, , Объект.ДатаПодписи);
		Объект.ПодписантФамилия = СокрЛП(ДанныеПредставителя.Фамилия);
		Объект.ПодписантИмя = СокрЛП(ДанныеПредставителя.Имя);
		Объект.ПодписантОтчество = СокрЛП(ДанныеПредставителя.Отчество);
	Иначе
		Объект.ПодписантФамилия = "";
		Объект.ПодписантИмя = "";
		Объект.ПодписантОтчество = "";
	КонецЕсли;
	
	УстановитьПодписанта();
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации()
	УстановитьПодписанта();
КонецПроцедуры

&НаСервере
Процедура УстановитьПодписанта()
	ДанныеУведомленияТитульный = ДанныеУведомления["Форма2017_1_Титульная"];
	ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ);
	Если ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ") <> Неопределено Тогда
		ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	Если ТекущиеМногострочныеЧасти.Количество() > 0 Тогда 
		УведомлениеОСпецрежимахНалогообложения.СобратьДанныеМногострочныхЧастейТекущейСтраницы(
					ЭтотОбъект, ТекущиеМногострочныеЧасти, УИДТекущаяСтраница);
	КонецЕсли;
	
	ДанныеДопСтрокБД = Новый Структура;
	Для Каждого КЗ Из ДанныеДопСтрок Цикл 
		ДанныеДопСтрокБД.Вставить(КЗ.Ключ, ПолучитьИзВременногоХранилища(КЗ.Значение));
	КонецЦикла;
	
	СтруктураПараметров = Новый Структура;
			
	СтруктураПараметров.Вставить("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
	СтруктураПараметров.Вставить("ДанныеДопСтрокБД", ДанныеДопСтрокБД);
	СтруктураПараметров.Вставить("ДеревоСтраниц", РеквизитФормыВЗначение("ДеревоСтраниц"));
	СтруктураПараметров.Вставить("ДанныеМногостраничныхРазделов", ДанныеМногостраничныхРазделов);
	СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеУведомления);
	СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");
	
	УведомлениеОСпецрежимахНалогообложения.СохранитьНастройкиРучногоВвода(ЭтотОбъект);
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(СсылкаНаДанные)
	СтруктураПараметров = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаДанные, "ДанныеУведомления").Получить();
	ДанныеУведомления = СтруктураПараметров.ДанныеУведомления;
	ДанныеМногостраничныхРазделов = СтруктураПараметров.ДанныеМногостраничныхРазделов;
	ЗначениеВРеквизитФормы(СтруктураПараметров.ДеревоСтраниц, "ДеревоСтраниц");
	СтруктураПараметров.Свойство("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
	СтруктураПараметров.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	ДанныеДопСтрокБД = СтруктураПараметров.ДанныеДопСтрокБД;
	ДанныеДопСтрок = Новый Структура;
	ДанныеДопСтрокСтраницы = Новый Структура;
	Для Каждого КЗ Из ДанныеДопСтрокБД Цикл 
		ДанныеДопСтрок.Вставить(КЗ.Ключ, ПоместитьВоВременноеХранилище(КЗ.Значение, Новый УникальныйИдентификатор));
		Стр = Новый Структура;
		Для Каждого Кол Из КЗ.Значение.Колонки Цикл 
			Если Кол.Имя <> "УИД" Тогда 
				Стр.Вставить(Кол.Имя);
			КонецЕсли;
		КонецЦикла;
		СЗ = Новый СписокЗначений;
		СЗ.Добавить(Стр);
		ДанныеДопСтрокСтраницы.Вставить(КЗ.Ключ, СЗ);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если ТекущийМакет = "Форма2017_1_Титульная" Тогда 
		Если Область.Имя = "КодНО" Тогда 
			СтандартнаяОбработка = Ложь;
			РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Область.Имя);
		КонецЕсли;
	ИначеЕсли  ТекущийМакет = "Форма2017_1_Лист2" И Область.Имя = "ВыводитьНольНаПечать" Тогда 
		Область.Значение = Не Область.Значение;
		СтандартнаяОбработка = Ложь;
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
		Возврат;
	КонецЕсли;
	
	Если УведомлениеОСпецрежимахНалогообложенияКлиент.ТиповойВыбор(ЭтотОбъект, Область, СтандартнаяОбработка) Или РучнойВвод Тогда 
		Возврат;
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка, Истина, Истина);
	КонецЕсли;
	
	Если Область.Имя = "КодРегион" И (ТекущееИДНаименования <> "Форма2017_1_Титульная") Тогда 
		Возврат;
	КонецЕсли;
	
	ВРЕГ_ИмяЯчейки = ВРЕГ(Область.Имя);
	Если (СтрНайти(ВРЕГ_ИмяЯчейки, "ИНДЕКС") = 1)
		ИЛИ (СтрНайти(ВРЕГ_ИмяЯчейки, "КОДРЕГИОН") = 1)
		ИЛИ (СтрНайти(ВРЕГ_ИмяЯчейки, "РАЙОН") = 1)
		ИЛИ (СтрНайти(ВРЕГ_ИмяЯчейки, "ГОРОД") = 1)
		ИЛИ (СтрНайти(ВРЕГ_ИмяЯчейки, "НАСЕЛПУНКТ") = 1)
		ИЛИ (СтрНайти(ВРЕГ_ИмяЯчейки, "УЛИЦА") = 1)
		ИЛИ (СтрНайти(ВРЕГ_ИмяЯчейки, "ДОМ") = 1)
		ИЛИ (СтрНайти(ВРЕГ_ИмяЯчейки, "КОРПУС") = 1)
		ИЛИ (СтрНайти(ВРЕГ_ИмяЯчейки, "КВАРТ")= 1) Тогда
		
		ТекСтраницаДанные = Неопределено;
		ЭтоТитульная = (ТекущееИДНаименования = "Форма2017_1_Титульная");
		Если ТекущееИДНаименования = "Форма2017_1_Титульная" Тогда 
			ТекСтраницаДанные = ДанныеУведомления.Форма2017_1_Титульная;
		Иначе
			Для Каждого Стр Из ДанныеМногостраничныхРазделов[ТекущееИДНаименования] Цикл 
				Если Стр.Значение.УИД = УИДТекущаяСтраница Тогда 
					ТекСтраницаДанные = Стр.Значение;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		СтандартнаяОбработка = Ложь;
		РоссийскийАдрес = Новый Соответствие;
		
		РоссийскийАдрес.Вставить("Индекс",			ПредставлениеУведомления.Области["Индекс"].Значение);
		РоссийскийАдрес.Вставить("КодРегиона",		ПредставлениеУведомления.Области[?(ЭтоТитульная, "КодРегион", "КодРегионАддр")].Значение);
		РоссийскийАдрес.Вставить("Район",			ПредставлениеУведомления.Области["Район"].Значение);
		РоссийскийАдрес.Вставить("Город",			ПредставлениеУведомления.Области["Город"].Значение);
		РоссийскийАдрес.Вставить("НаселенныйПункт",	ПредставлениеУведомления.Области["НаселПункт"].Значение);
		РоссийскийАдрес.Вставить("Улица",			ПредставлениеУведомления.Области["Улица"].Значение);
		РоссийскийАдрес.Вставить("Дом",				ПредставлениеУведомления.Области["Дом"].Значение);
		РоссийскийАдрес.Вставить("Корпус",			ПредставлениеУведомления.Области["Корпус"].Значение);
		РоссийскийАдрес.Вставить("Квартира",		ПредставлениеУведомления.Области["Кварт"].Значение);
		
		Если Регионы.Количество() = 0 Тогда
			ЗаполнитьРегионыНаСервере();
		КонецЕсли;
		
		Регион = Регионы.НайтиСтроки(Новый Структура("Код", СокрЛП(РоссийскийАдрес["КодРегиона"])));
		Если Регион.Количество() > 0 Тогда
			РоссийскийАдрес["Регион"] = Регион[0].Наим;
		КонецЕсли;
		
		ЗначенияПолей = Новый СписокЗначений;
		
		ЗначенияПолей.Добавить(РоссийскийАдрес["Индекс"],          "Индекс");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Регион"],          "Регион");
		ЗначенияПолей.Добавить(РоссийскийАдрес["КодРегиона"],      "КодРегиона");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Район"],           "Район");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Город"],           "Город");
		ЗначенияПолей.Добавить(РоссийскийАдрес["НаселенныйПункт"], "НаселенныйПункт");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Улица"],           "Улица");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Дом"],             "Дом");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Корпус"],          "Корпус");
		ЗначенияПолей.Добавить(РоссийскийАдрес["Квартира"],        "Квартира");
		
		ПредставлениеАдреса = РегламентированнаяОтчетностьКлиентСервер.ПредставлениеАдресаВФормате9Запятых("643," + РоссийскийАдрес["Индекс"] + ","
		+ РоссийскийАдрес["Регион"] + ","
		+ РоссийскийАдрес["Район"] + ","
		+ РоссийскийАдрес["Город"] + ","
		+ РоссийскийАдрес["НаселенныйПункт"] + ","
		+ РоссийскийАдрес["Улица"] + ","
		+ РоссийскийАдрес["Дом"] + ","
		+ РоссийскийАдрес["Корпус"] + ","
		+ РоссийскийАдрес["Квартира"]);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок",               "Ввод адреса");
		ПараметрыФормы.Вставить("Представление", 		   ПредставлениеАдреса);
		ПараметрыФормы.Вставить("ВидКонтактнойИнформации", ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресОрганизации"));
		Если ТекСтраницаДанные <> Неопределено Тогда 
			Если ТекСтраницаДанные.Свойство("АдресJSON") И ЗначениеЗаполнено(ТекСтраницаДанные.АдресJSON) Тогда 
				ПараметрыФормы.Вставить("КонтактнаяИнформация", ТекСтраницаДанные.АдресJSON);
				ПараметрыФормы.Вставить("ЗначенияПолей", ТекСтраницаДанные.АдресJSON);
			ИначеЕсли ЗначениеЗаполнено(ТекСтраницаДанные.АдресXML) Тогда 
				ПараметрыФормы.Вставить("КонтактнаяИнформация", ТекСтраницаДанные.АдресXML);
				ПараметрыФормы.Вставить("ЗначенияПолей", ТекСтраницаДанные.АдресXML);
			КонецЕсли;
			Если ЗначениеЗаполнено(ТекСтраницаДанные.Адрес9зпт) Тогда 
				ПараметрыФормы.Вставить("Представление", ТекСтраницаДанные.Адрес9зпт);
			КонецЕсли;
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("РоссийскийАдрес", РоссийскийАдрес);
		ДополнительныеПараметры.Вставить("ТекущееИДНаименования", ТекущееИДНаименования);
		ДополнительныеПараметры.Вставить("УИДТекущаяСтраница", УИДТекущаяСтраница);
		
		ТипЗначения = Тип("ОписаниеОповещения");
		ПараметрыКонструктора = Новый Массив(3);
		ПараметрыКонструктора[0] = "ОткрытьФормуКонтактнойИнформацииЗавершение";
		ПараметрыКонструктора[1] = ЭтотОбъект;
		ПараметрыКонструктора[2] = ДополнительныеПараметры;
		
		Оповещение = Новый (ТипЗначения, ПараметрыКонструктора);
		ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент").ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, , Оповещение);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРегионыНаСервере()
	РегламентированнаяОтчетность.ЗаполнитьРегионы(Регионы);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуКонтактнойИнформацииЗавершение(Результат, Параметры) Экспорт
	ОбновитьАдресВТабличномДокументе(Результат, Параметры.РоссийскийАдрес, Параметры.ТекущееИДНаименования, Параметры.УИДТекущаяСтраница);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьАдресВТабличномДокументе(Результат, РоссийскийАдрес, ТекущееИДНаименования, УИДТекущаяСтраница)
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ЭтоТитульная = (ТекущееИДНаименования = "Форма2017_1_Титульная");
		РоссийскийАдрес_ = РоссийскийАдрес;
		РегламентированнаяОтчетностьВызовСервера.СформироватьАдрес(Результат.КонтактнаяИнформация, РоссийскийАдрес_);
		
		ПредставлениеУведомления.Области["Индекс"].Значение = РоссийскийАдрес_["Индекс"];
		ПредставлениеУведомления.Области[?(ЭтоТитульная, "КодРегион", "КодРегионАддр")].Значение = РоссийскийАдрес_["КодРегиона"];
		ПредставлениеУведомления.Области["Район"].Значение = РоссийскийАдрес_["Район"];
		ПредставлениеУведомления.Области["Город"].Значение = РоссийскийАдрес_["Город"];
		ПредставлениеУведомления.Области["НаселПункт"].Значение = РоссийскийАдрес_["НаселенныйПункт"];
		ПредставлениеУведомления.Области["Улица"].Значение = РоссийскийАдрес_["Улица"];
		ПредставлениеУведомления.Области["Дом"].Значение = РоссийскийАдрес_["Дом"];
		ПредставлениеУведомления.Области["Корпус"].Значение = РоссийскийАдрес_["Корпус"];
		ПредставлениеУведомления.Области["Кварт"].Значение = РоссийскийАдрес_["Квартира"];
		
		ТекСтраницаДанные = Неопределено;
		Если ТекущееИДНаименования = "Форма2017_1_Титульная" Тогда 
			ТекСтраницаДанные = ДанныеУведомления.Форма2017_1_Титульная;
		Иначе
			Для Каждого Стр Из ДанныеМногостраничныхРазделов[ТекущееИДНаименования] Цикл 
				Если Стр.Значение.УИД = УИДТекущаяСтраница Тогда 
					ТекСтраницаДанные = Стр.Значение;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
		Если ТекСтраницаДанные <> Неопределено Тогда 
			ТекСтраницаДанные["Индекс"] = РоссийскийАдрес_["Индекс"];
			ТекСтраницаДанные[?(ЭтоТитульная, "КодРегион", "КодРегионАддр")] = РоссийскийАдрес_["КодРегиона"];
			ТекСтраницаДанные["Район"] = РоссийскийАдрес_["Район"];
			ТекСтраницаДанные["Город"] = РоссийскийАдрес_["Город"];
			ТекСтраницаДанные["НаселПункт"] = РоссийскийАдрес_["НаселенныйПункт"];
			ТекСтраницаДанные["Улица"] = РоссийскийАдрес_["Улица"];
			ТекСтраницаДанные["Дом"] = РоссийскийАдрес_["Дом"];
			ТекСтраницаДанные["Корпус"] = РоссийскийАдрес_["Корпус"];
			ТекСтраницаДанные["Кварт"] = РоссийскийАдрес_["Квартира"];
			
			Если Не ТекСтраницаДанные.Свойство("АдресJSON") Тогда 
				ТекСтраницаДанные.Вставить("АдресJSON");
			КонецЕсли;
			ТекСтраницаДанные["АдресJSON"] = Результат.Значение;
			ТекСтраницаДанные["АдресXML"] = Результат.КонтактнаяИнформация;
			ТекСтраницаДанные["Адрес9зпт"] = Результат.Представление;
		КонецЕсли;
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораПодписантаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОткрытьФормуВыбораПодписантаЗавершение(ЭтотОбъект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтраницу(Команда) Экспорт 
	ДобавитьСтраницуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтраницуНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ДобавитьСтраницуУведомления(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтраницу() Экспорт
	УдалениеСтраницы = Истина;
	УдалитьСтраницуНаСервере();
	УдалениеСтраницы = Ложь;
КонецПроцедуры

&НаСервере
Процедура УдалитьСтраницуНаСервере()
	Для Каждого Стр Из ТекущиеМногострочныеЧасти Цикл 
		ТЗ = ПолучитьИзВременногоХранилища(ДанныеДопСтрок[Стр.Значение]);
		Строки = ТЗ.НайтиСтроки(Новый Структура("УИД", УИДТекущаяСтраница));
		Для Каждого СтрМнг Из Строки Цикл 
			ТЗ.Удалить(СтрМнг);
		КонецЦикла;
		ДанныеДопСтрок[Стр.Значение] = ПоместитьВоВременноеХранилище(ТЗ, ДанныеДопСтрок[Стр.Значение]);
	КонецЦикла;
	
	УведомлениеОСпецрежимахНалогообложения.УдалитьСтраницуНаСервере(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Инфо = ДополнительныеПараметры.Инфо;
	
	Если Результат <> Неопределено Тогда 
		Объект.РегистрацияВИФНС = Результат;
		УстановитьДанныеПоРегистрацииВИФНС();
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

#Область ОтправкаВФНС
////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС
&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры
#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПроверитьДокументСВыводомВТаблицу(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ТаблицаОшибок = ПроверитьВыгрузкуНаСервере();
	Если ТаблицаОшибок.Количество() = 0 Тогда 
		ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибок не обнаружено");
	Иначе
		ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.НавигацияПоОшибкам", Новый Структура("ТаблицаОшибок", ТаблицаОшибок), ЭтотОбъект, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	ПечатьБРОНаСервере();
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(ЭтотОбъект, "Открыть", Ложь, СтруктураРеквизитовУведомления.СписокПечатаемыхЛистов);
КонецПроцедуры

&НаСервере
Процедура ПечатьБРОНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ПечатьУведомленияБРО(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РучнойВвод(Команда)
	РучнойВвод = Не РучнойВвод;
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаОповещенияНавигацииПоОшибкам(ЭтотОбъект, Параметр, Источник);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВыгружатьСОшибками(Команда)
	РазрешитьВыгружатьСОшибками = Не РазрешитьВыгружатьСОшибками;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтотОбъект);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСДвухмернымШтрихкодомPDF417(Команда)
	РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФормуУведомленияОСпецрежимах(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция СформироватьВыгрузкуИПолучитьДанные() Экспорт 
	Выгрузка = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если Выгрузка = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Выгрузка = Выгрузка[0];
	СтруктураВыгрузки = Новый Структура("ТестВыгрузки,КодировкаВыгрузки", 
			Выгрузка.ТестВыгрузки, Выгрузка.КодировкаВыгрузки);
	СтруктураВыгрузки.Вставить("Данные", УведомлениеОСпецрежимахНалогообложения.ПолучитьМакетДвоичныхДанных(Объект.ИмяОтчета, "TIFF_2017_1"));
	СтруктураВыгрузки.Вставить("ИмяФайла", "1150010_5.06000_06.tif");
	Возврат СтруктураВыгрузки;
КонецФункции

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Процедура РазрешитьРедактированиеРеквизитовОбъекта() Экспорт
	РегламентированнаяОтчетность.РазрешитьРедактированиеРеквизитовОтчета(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	РегламентированнаяОтчетностьКлиент.РазрешитьРедактированиеРеквизитовОтчета(ЭтотОбъект);
КонецПроцедуры
