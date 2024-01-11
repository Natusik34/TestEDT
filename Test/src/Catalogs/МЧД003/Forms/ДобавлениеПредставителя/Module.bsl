// @strict-types
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбщегоНазначенияБЭД.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	НачальноеЗаполнениеРеквизитов();
	Если ЭтоАдресВременногоХранилища(Параметры.ХранилищеДанных) Тогда
		ДанныеЗаполнения = ПолучитьИзВременногоХранилища(Параметры.ХранилищеДанных);
		ЗначениеВРеквизитФормы(ДанныеЗаполнения, "СвУпПред");
	КонецЕсли;
	ТипыПредставителей = ТипыПредставителей();
	Если СвУпПред[0].ТипПред = ТипыПредставителей.ЮридическоеЛицо Тогда
		ОтображаемаяГруппа = Элементы.ГруппаПредставитель_Организация;
	ИначеЕсли СвУпПред[0].ТипПред = ТипыПредставителей.ИндивидуальныйПредприниматель Тогда
		ОтображаемаяГруппа = Элементы.ГруппаПредставитель_ИндивидуальныйПредприниматель;
	Иначе
		ОтображаемаяГруппа = Элементы.ГруппаПредставитель_ФизическоеЛицо;
	КонецЕсли;
	ПоказатьГруппу(Элементы.ГруппаПредставитель, ОтображаемаяГруппа);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СвУпПред_ПредставительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОбработчикВыбранногоЗначения = Новый ОписаниеОповещения("Подключаемый_ВыборПредставителяЗавершение", ЭтотОбъект);
	НачатьВыборЗначенияСубъекта(ОбработчикВыбранногоЗначения, СписокВыбораТиповПредставителя, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СвУпПред_ПредставительАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание,
	СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Ожидание > 0 И ЗначениеЗаполнено(Текст) Тогда
		ДанныеВыбора = Подбор(Текст, СписокВыбораТиповПредставителя);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СвУпПред_ПредставительПриИзменении(Элемент)
	ПерезаполнитьСведенияОПредставителе(СвУпПред[0]._Представитель);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	Закрыть(ПолучитьАдресДанныхФормы(ВладелецФормы.УникальныйИдентификатор));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьАдресДанныхФормы(ИдентификаторВладельца)
	ДанныеПредставителя = ДанныеФормыВЗначение(СвУпПред, Тип("ТаблицаЗначений"));
	Возврат ПоместитьВоВременноеХранилище(ДанныеПредставителя, ИдентификаторВладельца);
КонецФункции

&НаКлиенте
Процедура НачатьВыборЗначенияСубъекта(ОбработчикВыбораЗначения, СписокТипов, Элемент)
	КоличествоТипов = СписокТипов.Количество();
	ОбработчикВыбораТипа = Новый ОписаниеОповещения("Подключаемый_ВыборТипаСубъектаЗавершение", ЭтотОбъект,
		Новый Структура("ОбработчикВыбораЗначения", ОбработчикВыбораЗначения));
	Если КоличествоТипов = 0 Тогда
		Возврат;
	ИначеЕсли КоличествоТипов = 1 Тогда
		ВыполнитьОбработкуОповещения(ОбработчикВыбораТипа, СписокТипов[0]);
	Иначе
		ПоказатьВыборИзМеню(ОбработчикВыбораТипа, СписокТипов, Элемент);
	КонецЕсли;
КонецПроцедуры

// Подключаемый выбор типа субъекта завершение.
// 
// Параметры:
//  ВыбранныйТип - ЭлементСпискаЗначений:
//  * Значение - Тип - тип субъекта, для которого нужно открыть форму выбора
//  ДополнительныеПараметры - Структура:
//  * ОбработчикВыбораЗначения - ОписаниеОповещения
&НаКлиенте
Процедура Подключаемый_ВыборТипаСубъектаЗавершение(ВыбранныйТип, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(ВыбранныйТип) = Тип("ЭлементСпискаЗначений") Тогда
		ПоказатьВводЗначения(ДополнительныеПараметры.ОбработчикВыбораЗначения, Неопределено,
			ВыбранныйТип.Представление, ВыбранныйТип.Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыборПредставителяЗавершение(ВыбранноеЗначение, ДополнительныеПараметры = Неопределено) Экспорт
	ТипЗначения = ТипЗнч(ВыбранноеЗначение);
	ЗначениеДопустимогоТипа = Ложь;
	Для Каждого ЭлементСписка Из СписокВыбораТиповПредставителя Цикл
		Если ЭлементСписка.Значение = ТипЗначения Тогда
			ЗначениеДопустимогоТипа = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если ЗначениеДопустимогоТипа И ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		ПерезаполнитьСведенияОПредставителе(ВыбранноеЗначение);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьСведенияОПредставителе(Представитель)
	Модифицированность = Истина;
	СвУпПред.Очистить();
	СоздатьРекурсивно(СвУпПред, "СвУпПред");
	ПредставительПоУмолчанию(ЭтотОбъект);
	ТипЗначения = ТипЗнч(Представитель);
	ТипыПредставителей = ТипыПредставителей();
	Если ЗначениеЗаполнено(Представитель) И ОбщегоНазначения.ЭтоСсылка(ТипЗначения) Тогда
		СвУпПред[0]._Представитель = Представитель;
		Если Метаданные.ОпределяемыеТипы.ФизическоеЛицо.Тип.СодержитТип(ТипЗначения) Тогда
			СтруктураСведений = МашиночитаемыеДоверенности.ДанныеФизЛица(Представитель);
			СвУпПред[0].ТипПред = ТипыПредставителей.ФизическоеЛицо;
			СведенияОФизЛице = СвУпПред[0].Пред[0].СведФизЛ[0];
			СведенияОФизЛице.ИННФЛ = СтруктураСведений.ИНН;
			СведенияОФизЛице.СНИЛС = СтруктураСведений.СтраховойНомерПФР;
			ЗаполнитьТаблицуТипаСведФЛ(СведенияОФизЛице.СведФЛ[0], СтруктураСведений);
			ПоказатьГруппу(Элементы.ГруппаПредставитель, Элементы.ГруппаПредставитель_ФизическоеЛицо);
		Иначе
			СтруктураСведений = ОбщегоНазначенияБЭД.ДанныеЮрФизЛица(Представитель);
			Если ИнтеграцияЭДО.ЭтоФизЛицо(Представитель) Тогда
				СвУпПред[0].ТипПред = ТипыПредставителей.ИндивидуальныйПредприниматель;
				СведенияОбИП = СвУпПред[0].Пред[0].СведИП[0];
				СведенияОбИП.НаимИП = СтруктураСведений.ПолноеНаименование;
				СведенияОбИП.ИННФЛ = СтруктураСведений.ИНН;
				СведенияОбИП.ОГРНИП = СтруктураСведений.ОГРН;
				СведенияОбИП.СведФЛ[0].ФИО[0].Фамилия = СтруктураСведений.Фамилия;
				СведенияОбИП.СведФЛ[0].ФИО[0].Имя = СтруктураСведений.Имя;
				СведенияОбИП.СведФЛ[0].ФИО[0].Отчество = СтруктураСведений.Отчество;
				ПоказатьГруппу(Элементы.ГруппаПредставитель, Элементы.ГруппаПредставитель_ИндивидуальныйПредприниматель);
			Иначе
				СвУпПред[0].ТипПред = ТипыПредставителей.ЮридическоеЛицо;
				СведенияОЮрЛице = СвУпПред[0].Пред[0].СведОрг[0];
				СведенияОЮрЛице.НаимОрг = СтруктураСведений.ПолноеНаименование;
				СведенияОЮрЛице.ИННЮЛ = СтруктураСведений.ИНН;
				СведенияОЮрЛице.КПП = СтруктураСведений.КПП;
				СведенияОЮрЛице.ОГРН = СтруктураСведений.ОГРН;
				СведенияОЮрЛице.АдрРег[0].АдрРФ = СтруктураСведений.ЮридическийАдрес;
				ПоказатьГруппу(Элементы.ГруппаПредставитель, Элементы.ГруппаПредставитель_Организация);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьТаблицуТипаСведФЛ(СведФЛ, СтруктураСведений)
	СведФЛ.ФИО[0].Фамилия = СтруктураСведений.Фамилия;
	СведФЛ.ФИО[0].Имя = СтруктураСведений.Имя;
	СведФЛ.ФИО[0].Отчество = СтруктураСведений.Отчество;
	СведФЛ.ДатаРожд = СтруктураСведений.ДатаРождения;
	Ключи = "КемВыдан, ДатаВыдачи, КодФНС, КодПодразделения, Серия, Номер";
	СведенияУдостоверения = Новый Структура(Ключи);
	ЗаполнитьЗначенияСвойств(СведенияУдостоверения, СтруктураСведений);
	СведФЛ.УдЛичнФЛ[0].ВыдДок = СведенияУдостоверения.КемВыдан;
	СведФЛ.УдЛичнФЛ[0].ДатаДок = СведенияУдостоверения.ДатаВыдачи;
	СведФЛ.УдЛичнФЛ[0].КодВидДок = СведенияУдостоверения.КодФНС;
	СведФЛ.УдЛичнФЛ[0].КодВыдДок = СведенияУдостоверения.КодПодразделения;
	СведФЛ.УдЛичнФЛ[0].СерНомДок = СтрШаблон("%1 %2", СведенияУдостоверения.Серия, СведенияУдостоверения.Номер);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПредставительПоУмолчанию(Форма)
	Форма.СвУпПред[0]._Представитель = "";
	Форма.СвУпПред[0].ТипПред = ТипыПредставителей().ФизическоеЛицо;
	ПоказатьГруппу(Форма.Элементы.ГруппаПредставитель, Форма.Элементы.ГруппаПредставитель_ФизическоеЛицо);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТипыПредставителей()
	ТипыПредставителей = Новый Структура;
	ТипыПредставителей.Вставить("ЮридическоеЛицо", "1");
	ТипыПредставителей.Вставить("ИндивидуальныйПредприниматель", "2");
	ТипыПредставителей.Вставить("ФизическоеЛицо", "3");
	ТипыПредставителей.Вставить("ФилиалЮридическогоЛица", "4");
	ТипыПредставителей.Вставить("ФилиалИностраннойОрганизации", "5");
	Возврат Новый ФиксированнаяСтруктура(ТипыПредставителей);
КонецФункции

&НаСервере
Процедура СоздатьРекурсивно(НовыйОбъект, Путь)
	Запись = НовыйОбъект.Добавить();
	Для Каждого Реквизит Из ПолучитьРеквизиты(Путь) Цикл
		Если Реквизит.ТипЗначения.СодержитТип(Тип("ТаблицаЗначений")) Тогда
			СоздатьРекурсивно(Запись[Реквизит.Имя], СтрШаблон("%1.%2", Путь, Реквизит.Имя));
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура НачальноеЗаполнениеРеквизитов()
	СоздатьРекурсивно(СвУпПред, "СвУпПред");
	ПредставительПоУмолчанию(ЭтотОбъект);
	ЗаполнитьСпискиВыбораТипов();
	ЗаполнитьСписокВидовДокументовФизическогоЛица();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбораТипов()
	ТипыСубъектов = Новый Структура("ФизическоеЛицо, Организация, Контрагент",
		Метаданные.ОпределяемыеТипы.ФизическоеЛицо.Тип.Типы(), Метаданные.ОпределяемыеТипы.Организация.Тип.Типы(),
		Метаданные.ОпределяемыеТипы.КонтрагентБЭД.Тип.Типы());

	ШаблонПредставления = НСтр("ru='Выбрать %1';");
	Для Каждого КлючИЗначение Из ТипыСубъектов Цикл
		Для Каждого ТипСубъекта Из КлючИЗначение.Значение Цикл
			МетаданныеТипа = Метаданные.НайтиПоТипу(ТипСубъекта);
			Если МетаданныеТипа = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ВариантыИмени = Новый Структура("Синоним, ПредставлениеОбъекта", "", "");
			ЗаполнитьЗначенияСвойств(ВариантыИмени, МетаданныеТипа);
			ВыбранноеИмя = ?(ЗначениеЗаполнено(ВариантыИмени.ПредставлениеОбъекта), ВариантыИмени.ПредставлениеОбъекта,
				ВариантыИмени.Синоним);
			Представление = СтрШаблон(ШаблонПредставления, ПолучитьСклоненияСтроки(НРег(ВыбранноеИмя), ,
				"ПД=Винительный;")[0]);
			СписокВыбораТиповПредставителя.Добавить(ТипСубъекта, Представление);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВидовДокументовФизическогоЛица()
	Элементы.СвУпПредПредСведФизЛСведФЛУдЛичнФЛКодВидДок.СписокВыбора.Очистить();
	Элементы.СвУпПредПредСведИПСведФЛУдЛичнФЛКодВидДок.СписокВыбора.Очистить();
	ВидыДокументов = МашиночитаемыеДоверенностиКлиентСервер.ВидыДокументовФизическихЛиц();
	Для Каждого ВидДок Из ВидыДокументов Цикл
		Элементы.СвУпПредПредСведФизЛСведФЛУдЛичнФЛКодВидДок.СписокВыбора.Добавить(ВидДок.Ключ, ВидДок.Значение);
		Элементы.СвУпПредПредСведИПСведФЛУдЛичнФЛКодВидДок.СписокВыбора.Добавить(ВидДок.Ключ, ВидДок.Значение);
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция Подбор(Знач СтрокаПоиска, Знач СписокТипов)
	Лимит = 10;
	ПараметрыПодбора = Новый Структура("СтрокаПоиска, СпособПоискаСтроки", СтрокаПоиска,
		СпособПоискаСтрокиПриВводеПоСтроке.ЛюбаяЧасть);
	ИтоговыйСписок = Новый СписокЗначений;
	Индекс = 1;
	Для Каждого ЭлементСписка Из СписокТипов Цикл
		ТекущийТип = ЭлементСписка.Значение;
		МетаданныеИсточника = Метаданные.НайтиПоТипу(ТекущийТип);
		Если ТипЗнч(МетаданныеИсточника) <> Тип("Неопределено") И Метаданные.Справочники.Содержит(МетаданныеИсточника) Тогда
			ИмяСправочника = МетаданныеИсточника.Синоним;
			Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеИсточника.ПолноеИмя());
			ДанныеВыбора = Менеджер.ПолучитьДанныеВыбора(ПараметрыПодбора);
			Для Каждого ЭлементВыбора Из ДанныеВыбора Цикл
				ЧастиПредставления = Новый Массив(2);
				ЧастиПредставления[0] = ЭлементВыбора.Представление;
				ЧастиПредставления[1] = Новый ФорматированнаяСтрока(СтрШаблон(" [%1]", ИмяСправочника), ,
					ЦветаСтиля.НедоступныйДляВыбораЭлементБЭД);
				ИтоговыйСписок.Добавить(ЭлементВыбора.Значение, Новый ФорматированнаяСтрока(ЧастиПредставления));
				Если Индекс >= Лимит Тогда
					Возврат ИтоговыйСписок;
				КонецЕсли;
				Индекс = Индекс + 1;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	Возврат ИтоговыйСписок;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьГруппу(Родитель, Потомок)
	Для Каждого ВложеннаяГруппа Из Родитель.ПодчиненныеЭлементы Цикл
		Если ТипЗнч(ВложеннаяГруппа) = Тип("ГруппаФормы") Тогда
			ВложеннаяГруппа.Видимость = ВложеннаяГруппа = Потомок;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти