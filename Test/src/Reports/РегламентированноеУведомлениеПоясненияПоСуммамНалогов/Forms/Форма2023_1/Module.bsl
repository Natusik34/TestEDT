
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
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Данные = Неопределено;
	ДанныеИзвещения = Неопределено;
	Параметры.Свойство("Данные", Данные);
	Параметры.Свойство("ЗаполнитьПриОткрытии", ЗаполнитьПриОткрытии);
	Параметры.Свойство("ДанныеИзвещения", ДанныеИзвещения);
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПоясненияПоСуммамНалогов;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2023_1");
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		УведомлениеОСпецрежимахНалогообложения.ЗагрузитьДанныеПростогоУведомления(ЭтотОбъект, Данные, ПредставлениеУведомления);
	ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Организация = Параметры.Ключ.Организация;
		ЗагрузитьДанные(Параметры.Ключ);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Организация = Параметры.ЗначениеКопирования.Организация;
		ЭтоЮЛ = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация);
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	ИначеЕсли Параметры.Свойство("ПредставлениеXML") Тогда 
		Параметры.Свойство("РегистрацияВНалоговомОргане", Объект.РегистрацияВИФНС);
		Параметры.Свойство("Организация", Объект.Организация);
		ЗагрузитьИзXMLНаСервере(Новый Структура("Организация, РегистрацияВНалоговомОргане, ПредставлениеXML", 
								Объект.Организация, Объект.РегистрацияВИФНС, Параметры.ПредставлениеXML));
	Иначе
		Параметры.Свойство("Организация", Объект.Организация);
		Параметры.Свойство("РегистрацияВНалоговомОргане", Объект.РегистрацияВИФНС);
		Если Не ЗначениеЗаполнено(Объект.РегистрацияВИФНС) Тогда
			Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		КонецЕсли;
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		ЗаполнитьНачальныеДанные();
	КонецЕсли;
	
	Если ТипЗнч(ДанныеИзвещения) = Тип("Структура") Тогда 
		ЗагрузитьДанныеВходящегоИзвещения(ДанныеИзвещения);
	КонецЕсли;
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	Заголовок = УведомлениеОСпецрежимахНалогообложения.ДополнитьЗаголовокУведомления(Заголовок, Объект.Организация);
	ИдДляСвор = УведомлениеОСпецрежимахНалогообложения.ПолучитьИдентификаторыДляСворачивания(ЭтотОбъект);
	СворачиваемыеЭлементы = ПоместитьВоВременноеХранилище(ИдДляСвор, УникальныйИдентификатор);
	РучнойВвод = Ложь;
	ЦФБ = Новый Цвет(255, 255, 255);
	
	ИДОтчета = Лев(ИмяФормы, СтрНайти(ИмяФормы, ".Форма.") - 1);
	ИДРедакцииОтчета = Сред(ИмяФормы, СтрНайти(ИмяФормы, ".Форма.") + 7);
	ПараметрыОтчета = Новый Структура("Организация, ДатаПодписи, РегистрацияВИФНС",
		Объект.Организация, Объект.ДатаПодписи, Объект.РегистрацияВИФНС);
	ПоказателиОтчета = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОПоказателяхОтчета(
		ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета);
		
	Если ТипЗнч(ПоказателиОтчета) = Тип("Структура")
		И ПоказателиОтчета.Количество() > 0 Тогда 
			
		Для Каждого КЗ Из ПоказателиОтчета Цикл 
			ЗаполняемыеРеквизиты.Добавить(КЗ.Ключ);
		КонецЦикла;
		ЕстьПодборИзКлассификатора = Истина;
	Иначе
		Элементы.ФормаЗаполнить.Видимость = Ложь;
	КонецЕсли;
	ЦветФонаАвто = Новый Цвет(230, 240, 220);
	УведомлениеОСпецрежимахНалогообложения.СпрятатьКнопкиВыгрузкиОтправкиУНеактуальныхФорм(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеВходящегоИзвещения(ДанныеИзвещения)
	Титульная = ДанныеУведомления["Титульная"];
	Титульная.ДатаСообщ = ДанныеИзвещения.ДатаДокумента;
	Титульная.НомерСообщ = ДанныеИзвещения.НомерДокумента;
	
	УИДТекущаяСтраница = ДанныеМногостраничныхРазделов["ПояснТС"][0].Значение.УИД;
	Пока ДанныеМногостраничныхРазделов["ПояснТС"].Количество() < ДанныеИзвещения.ПоясненияТранспортныеСредства.Количество() Цикл 
		УведомлениеОСпецрежимахНалогообложения.ДобавитьСтраницуУведомления(ЭтотОбъект);
	КонецЦикла;
	Для Инд = 0 По ДанныеИзвещения.ПоясненияТранспортныеСредства.ВГраница() Цикл 
		ЗаполнитьЗначенияСвойств(
			ДанныеМногостраничныхРазделов["ПояснТС"][Инд].Значение,
			ДанныеИзвещения.ПоясненияТранспортныеСредства[Инд]);
	КонецЦикла;
	
	УИДТекущаяСтраница = ДанныеМногостраничныхРазделов["ПояснОбНедв"][0].Значение.УИД;
	Пока ДанныеМногостраничныхРазделов["ПояснОбНедв"].Количество() < ДанныеИзвещения.ПоясненияНедвижимость.Количество() Цикл 
		УведомлениеОСпецрежимахНалогообложения.ДобавитьСтраницуУведомления(ЭтотОбъект);
	КонецЦикла;
	Для Инд = 0 По ДанныеИзвещения.ПоясненияНедвижимость.ВГраница() Цикл 
		ЗаполнитьЗначенияСвойств(
			ДанныеМногостраничныхРазделов["ПояснОбНедв"][Инд].Значение,
			ДанныеИзвещения.ПоясненияНедвижимость[Инд]);
	КонецЦикла;
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
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	Если ЗаполнитьПриОткрытии Тогда 
		Заполнить(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаОповещенияНавигацииПоОшибкам(ЭтотОбъект, Параметр, Источник);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Заполнить(Команда)
	Доступность = Ложь;
	РезультатВыполнения = ЗаполнитьАвтоНаСервере();
	Если НЕ РезультатВыполнения.ЗаданиеВыполнено Тогда
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗаполнитьАвтоЗавершениеПослеЗаполнения", ЭтотОбъект);
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Выполняется заполнение по данным информационной базы'");
		ДлительныеОперацииКлиент.ОжидатьЗавершение(РезультатВыполнения, ОповещениеОЗавершении, ПараметрыОжидания);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьАвтоЗавершениеПослеЗаполнения(РезультатЗагрузки, ДополнительныеПараметры) Экспорт
	Доступность = Истина;
	
	Если РезультатЗагрузки = Неопределено
		ИЛИ РезультатЗагрузки.Статус <> "Выполнено" Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не удалось выполнить автозаполнение...'"));
		Возврат;
	КонецЕсли;

	ЗагрузитьПодготовленныеДанные();
КонецПроцедуры

&НаСервере
Функция ЗаполнитьАвтоНаСервере()
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("Организация", Объект.Организация);
	ПараметрыОтчета.Вставить("УникальныйИдентификаторФормы", УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("ВидУведомления", Объект.ВидУведомления);
	ПараметрыОтчета.Вставить("РегистрацияВИФНС", Объект.РегистрацияВИФНС);
	ПараметрыОтчета.Вставить("ДатаПодписи", Объект.ДатаПодписи);
	Контейнер = Новый Структура();
	
	ОТУИД = Новый ОписаниеТипов("УникальныйИдентификатор");
	Для Каждого КЗ Из ДанныеМногостраничныхРазделов Цикл 
		ДанныеСтраницы = ОбщегоНазначения.СкопироватьРекурсивно(КЗ.Значение[0].Значение);
		ТЗСтр = Новый ТаблицаЗначений;
		Для Каждого Кол Из ДанныеСтраницы Цикл 
			ТЗСтр.Колонки.Добавить(Кол.Ключ, ?(ТипЗнч(Кол.Значение) = Тип("УникальныйИдентификатор"), ОТУИД, Неопределено))
		КонецЦикла;
		Контейнер.Вставить(КЗ.Ключ, ТЗСтр);
	КонецЦикла;
	
	Контейнер.Вставить("РегистрацияВИФНС", Объект.РегистрацияВИФНС);
	Контейнер.Вставить("ДатаПодписи", Объект.ДатаПодписи);
	
	ЭтаФормаИмя = СтрЗаменить(ИмяФормы, "Отчет.", "");
	ИДОтчета = Лев(ЭтаФормаИмя, СтрНайти(ЭтаФормаИмя, ".Форма.") - 1);
	ИДРедакцииОтчета = Сред(ИмяФормы, СтрНайти(ИмяФормы, ".Форма.") + 7);
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.ЗапуститьВФоне = Истина;
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне("РегламентированнаяОтчетность.ЗаполнитьОтчетВФоне_Уведомления",
		Новый Структура("ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета, Контейнер", ИДОтчета, ИДРедакцииОтчета, ПараметрыОтчета, Контейнер),
		ПараметрыВыполненияВФоне);
	
	РезультатВыполнения.Вставить("ЗаданиеВыполнено", НРег(РезультатВыполнения.Статус) = "выполнено");
	АдресХранилища       = РезультатВыполнения.АдресРезультата;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат РезультатВыполнения;
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	СтруктураДанных.Контейнер.Свойство("РегистрацияВИФНС", Объект.РегистрацияВИФНС);
	СтруктураДанных.Контейнер.Свойство("ДатаПодписи", Объект.ДатаПодписи);
	ДанныеУведомления.Титульная["КодНО"] = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код");
	ДанныеУведомления.Титульная["ДАТА_ПОДПИСИ"] = Объект.ДатаПодписи;
	
	Для Каждого КЗ Из ДанныеМногостраничныхРазделов Цикл 
		КЗ.Значение.Очистить();
	КонецЦикла;
	
	Для Каждого КЗ Из СтруктураДанных.Контейнер.ПояснТС Цикл 
		СтруктураСтраницы = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(КЗ);
		ДанныеМногостраничныхРазделов.ПояснТС.Добавить(СтруктураСтраницы);
	КонецЦикла;
	Для Каждого КЗ Из СтруктураДанных.Контейнер.ПояснОбНедв Цикл 
		СтруктураСтраницы = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(КЗ);
		ДанныеМногостраничныхРазделов.ПояснОбНедв.Добавить(СтруктураСтраницы);
	КонецЦикла;
	
	Если СтруктураДанных.Контейнер.ПояснТС.Количество() = 0 Тогда
		ДанныеМногостраничныхРазделов.ПояснТС.Добавить(ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтруктураДанных.Контейнер.ПояснТС.Добавить()));
		ДанныеМногостраничныхРазделов.ПояснТС[0].Значение.УИД = Новый УникальныйИдентификатор;
	КонецЕсли;
	Если СтруктураДанных.Контейнер.ПояснОбНедв.Количество() = 0 Тогда
		ДанныеМногостраничныхРазделов.ПояснОбНедв.Добавить(ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтруктураДанных.Контейнер.ПояснОбНедв.Добавить()));
		ДанныеМногостраничныхРазделов.ПояснОбНедв[0].Значение.УИД = Новый УникальныйИдентификатор;
	КонецЕсли;
	
	КорневойУровень = ДеревоСтраниц.ПолучитьЭлементы();
	КорневойУровень.Удалить(1);
	КорневойУровень.Удалить(1);
	
	СтрРег = КорневойУровень.Добавить();
	СтрРег.Наименование = "Пояснения в отношении" + символы.ПС + "транспортного средства";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	Для Каждого Стр Из ДанныеМногостраничныхРазделов.ПояснТС Цикл 
		СтрРегТр = СтрРег.ПолучитьЭлементы().Добавить();
		СтрРегТр.Наименование = "Стр. " + (ДанныеМногостраничныхРазделов.Транспорт.Индекс(Стр) + 1);
		СтрРегТр.ИндексКартинки = 1;
		СтрРегТр.ИмяМакета = "ПояснТС_2023";
		СтрРегТр.Многостраничность = Истина;
		СтрРегТр.Многострочность = Ложь;
		СтрРегТр.УИД = Стр.Значение.УИД;
		СтрРегТр.ИДНаименования = "ПояснТС";
	КонецЦикла;
	
	СтрРег = КорневойУровень.Добавить();
	СтрРег.Наименование = "Пояснения в отношении" + символы.ПС + "объекта недвижимости";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	Для Каждого Стр Из ДанныеМногостраничныхРазделов.ПояснОбНедв Цикл 
		СтрРегТр = СтрРег.ПолучитьЭлементы().Добавить();
		СтрРегТр.Наименование = "Стр. " + (ДанныеМногостраничныхРазделов.Транспорт.Индекс(Стр) + 1);
		СтрРегТр.ИндексКартинки = 1;
		СтрРегТр.ИмяМакета = "ПояснОбНедв_2023";
		СтрРегТр.Многостраничность = Истина;
		СтрРегТр.Многострочность = Ложь;
		СтрРегТр.УИД = Стр.Значение.УИД;
		СтрРегТр.ИДНаименования = "ПояснОбНедв";
	КонецЦикла;

	ТекущееИДНаименования = "Титульная";
	ПоказатьТекущуюСтраницу("Титульная_2023", Неопределено);
	Модифицированность = Истина;
	Доступность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОчиститьУведомление(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОчисткаОтчета() Экспорт
	Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
	СформироватьДеревоСтраниц();
	УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
	ЗаполнитьНачальныеДанные();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачальныеДанные() Экспорт
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ДанныеУведомленияТитульный.Вставить("КодНО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код"));
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", Объект.ДатаПодписи);
	
	СтрокаСведений = "ИННЮЛ,НаимЮЛПол,КППЮЛ,ТелОрганизации";
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
	ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННЮЛ);
	ДанныеУведомленияТитульный.Вставить("НаимОрг", СведенияОбОрганизации.НаимЮЛПол);
	ДанныеУведомленияТитульный.Вставить("КПП", СведенияОбОрганизации.КППЮЛ);
	ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелОрганизации);
	
	Реквизиты = РегистрацияВНОСервер.ДанныеРегистрации(Объект.РегистрацияВИФНС);
	ДанныеУведомленияТитульный.Вставить("КодНО", Реквизиты.Код);
	ДанныеУведомленияТитульный.Вставить("КПП", Реквизиты.КПП);
	
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УведомлениеОСпецрежимахНалогообложения.УстановитьПредставителяПоФизЛицу(ЭтотОбъект);
	Иначе
		УведомлениеОСпецрежимахНалогообложения.УстановитьПредставителяПоОрганизации(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраниц() Экспорт
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	КорневойУровень = ДеревоСтраниц.ПолучитьЭлементы();
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Титульная страница";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Титульная_2023";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Титульная";
	Стр001.МакетыПФ = "Печать_Форма2023_1_Титульная";
	
	СтрРег = КорневойУровень.Добавить();
	СтрРег.Наименование = "Пояснения в отношении" + символы.ПС + "транспортного средства";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	
	СтрРег = СтрРег.ПолучитьЭлементы().Добавить();
	СтрРег.Наименование = "Стр. 1";
	СтрРег.ИндексКартинки = 1;
	СтрРег.ИмяМакета = "ПояснТС_2023";
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Ложь;
	СтрРег.УИД = Новый УникальныйИдентификатор;
	СтрРег.ИДНаименования = "ПояснТС";
	
	СтрРег = КорневойУровень.Добавить();
	СтрРег.Наименование = "Пояснения в отношении" + символы.ПС + "объекта недвижимости";
	СтрРег.ИндексКартинки = 1;
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Истина;
	
	СтрРег = СтрРег.ПолучитьЭлементы().Добавить();
	СтрРег.Наименование = "Стр. 1";
	СтрРег.ИндексКартинки = 1;
	СтрРег.ИмяМакета = "ПояснОбНедв_2023";
	СтрРег.Многостраничность = Истина;
	СтрРег.Многострочность = Ложь;
	СтрРег.УИД = Новый УникальныйИдентификатор;
	СтрРег.ИДНаименования = "ПояснОбНедв";
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
		ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, ПредУИД);
	Иначе 
		ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета, ПредУИД);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, ПредУИД)
	УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюМногостраничнуюСтраницу(ЭтотОбъект, ИмяМакета);
	РаскраситьАвтозаполняемыеЯчейки();
КонецПроцедуры

&НаСервере
Процедура РаскраситьАвтозаполняемыеЯчейки()
	Для Каждого Элт Из ЗаполняемыеРеквизиты Цикл 
		Обл = ПредставлениеУведомления.Области.Найти(Элт.Значение);
		Если Обл <> Неопределено Тогда 
			Обл.ЦветФона = ЦветФонаАвто;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета, ПредУИД)
	УведомлениеОСпецрежимахНалогообложения.ПоказатьТекущуюСтраницу(ЭтотОбъект, ИмяМакета, ПредУИД);
	РаскраситьАвтозаполняемыеЯчейки();
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
	
	Если Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	Реквизиты = РегистрацияВНОСервер.ДанныеРегистрации(Объект.РегистрацияВИФНС);
	ПредставлениеУведомления.Области["КодНО"].Значение = Реквизиты.Код;
	ПредставлениеУведомления.Области["КПП"].Значение = Реквизиты.КПП;
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ДанныеУведомленияТитульный.Вставить("КодНО", ПредставлениеУведомления.Области["КодНО"].Значение);
	ДанныеУведомленияТитульный.Вставить("КПП", ПредставлениеУведомления.Области["КПП"].Значение);
	
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УведомлениеОСпецрежимахНалогообложения.УстановитьПредставителяПоФизЛицу(ЭтотОбъект);
	Иначе
		УведомлениеОСпецрежимахНалогообложения.УстановитьПредставителяПоОрганизации(ЭтотОбъект);
	КонецЕсли;
	
	ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение);
	ДанныеУведомленияТитульный.Вставить("НаимДок", ПредставлениеУведомления.Области["НаимДок"].Значение);
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", ПредставлениеУведомления.Области["ДАТА_ПОДПИСИ"].Значение);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение);
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДеревоСтраниц", РеквизитФормыВЗначение("ДеревоСтраниц"));
	СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеУведомления);
	СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	СтруктураПараметров.Вставить("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
	СтруктураПараметров.Вставить("ДанныеМногостраничныхРазделов", ДанныеМногостраничныхРазделов);
	
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
	СтруктураПараметров.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	СтруктураПараметров.Свойство("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
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
	УведомлениеОСпецрежимахНалогообложения.УдалитьСтраницуНаСервере(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура СкопироватьСтраницуНаСервере()
	УведомлениеОСпецрежимахНалогообложения.КопироватьСтраницуУведомления(ЭтотОбъект, Истина);
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтраницуНаКлиенте() Экспорт 
	СкопироватьСтраницуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если УведомлениеОСпецрежимахНалогообложенияКлиент.ТиповойВыбор(ЭтотОбъект, Область, СтандартнаяОбработка) Или РучнойВвод Тогда 
		Возврат;
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка, Истина);
	КонецЕсли;
	
	Если Область.Имя = "КодНО" Тогда 
		СтандартнаяОбработка = Ложь;
		РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Область.Имя);
	КонецЕсли;
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

&НаКлиенте
Процедура ОткрытьФормуВыбораПодписантаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОткрытьФормуВыбораПодписантаЗавершение(ЭтотОбъект, Результат);
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

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтотОбъект);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
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
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибок не обнаружено");
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
Процедура РазрешитьВыгружатьСОшибками(Команда)
	РазрешитьВыгружатьСОшибками = Не РазрешитьВыгружатьСОшибками;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзXML(ПараметрыЗагрузкиXML) Экспорт
	ЗагрузитьИзXMLНаСервере(ПараметрыЗагрузкиXML);
	Элементы.ДеревоСтраниц.ТекущаяСтрока = ДеревоСтраниц.ПолучитьЭлементы()[0].ПолучитьИдентификатор();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьИзXMLНаСервере(ПараметрыЗагрузкиXML)
	ДеревоЗагрузки = УведомлениеОСпецрежимахНалогообложения.СформироватьДеревоЗагрузки(ПараметрыЗагрузкиXML.ПредставлениеXML);
	СхемаВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2023_1");
	УведомлениеОСпецрежимахНалогообложения.УстановитьОрганизациюПоПараметрамЗагрузки(ЭтотОбъект, ПараметрыЗагрузкиXML);
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	СформироватьДеревоСтраниц();
	УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
	
	ДополнительныеПараметры = Новый Структура;
	УведомлениеОСпецрежимахНалогообложения.ЗагрузитьОбычныеСтраницы(ЭтотОбъект, ДеревоЗагрузки, СхемаВыгрузки, ДополнительныеПараметры);
	УведомлениеОСпецрежимахНалогообложения.ЗагрузитьМногостраничныеСтраницы(ЭтотОбъект, ДеревоЗагрузки, СхемаВыгрузки, ДополнительныеПараметры);
	ЭтоЮЛ = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайлаВФормуУведомление(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ЗагрузитьИзФайлаУведомление(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура РазрешитьРедактированиеРеквизитовОбъекта() Экспорт
	РегламентированнаяОтчетность.РазрешитьРедактированиеРеквизитовОтчета(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	РегламентированнаяОтчетностьКлиент.РазрешитьРедактированиеРеквизитовОтчета(ЭтотОбъект);
КонецПроцедуры
