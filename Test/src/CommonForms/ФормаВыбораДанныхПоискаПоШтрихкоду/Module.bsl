
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗначенияПоиска = Неопределено;
	Если НЕ Параметры.Свойство("ЗначенияПоиска", ЗначенияПоиска) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуНоменклатурыДляОстатков(ЗначенияПоиска);
	
	Если ТаблицаНоменклатурыДляОстатков.Количество() > 0 Тогда
		
		НастройкиВыбора = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиФормыВыбораДанныхПоискаПоШК", "");
		Если ТипЗнч(НастройкиВыбора) = Тип("Структура") Тогда
			Если НастройкиВыбора.Свойство("ПоказыватьОстатокНоменклатуры") Тогда
				ПоказыватьОстатокНоменклатуры = НастройкиВыбора.ПоказыватьОстатокНоменклатуры;
			КонецЕсли;
			Если НастройкиВыбора.Свойство("СкладОстатков") Тогда
				СкладОстатков = НастройкиВыбора.СкладОстатков;
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СкладОстатков) Тогда
			РаботаСоШтрихкодамиПереопределяемый.ЗаполнитьТекущийСклад(СкладОстатков);
		КонецЕсли;
		
		Элементы.СкладОстатков.Доступность = ПоказыватьОстатокНоменклатуры;
		Элементы.КолонкиОстатка.Видимость = ПоказыватьОстатокНоменклатуры;
		
	Иначе
		
		Если Параметры.Свойство("ПоказыватьБонусы") Тогда
			Элементы.ТаблицаВыбораШаблонШтрихкода.Видимость = Ложь;
			Элементы.КолонкиОстатка.Видимость = Истина;
			Элементы.ТаблицаВыбораРезерв.Видимость = Ложь;
		Иначе
			Элементы.КолонкиОстатка.Видимость = Ложь;
		КонецЕсли;
		Элементы.СкладОстатков.Доступность 			= Ложь;
		Элементы.ГруппаПоказыватьОстаток.Видимость	= Ложь;
		
	КонецЕсли;
		
	Параметры.Свойство("Штрихкод", Штрихкод);
	Параметры.Свойство("ДанныеПО", Штрихкод);
	Параметры.Свойство("МагнитныйКод", МагнитныйКод);
	Элементы.ТаблицаВыбораВыбрана.Видимость = Ложь;
	Элементы.ТаблицаВыбораКодПоиска.Видимость = Ложь;
	СтрокаЗаголовка = "";
	
	Если ЗначениеЗаполнено(Штрихкод) Тогда
		СтрокаЗаголовка = НСтр("ru = 'Выбор данных поиска по штрихкоду %1'");
		СтрокаЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, Штрихкод);
	Иначе
		СтрокаЗаголовка = НСтр("ru = 'Выбор данных поиска по магнитному коду %1'");
		СтрокаЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, МагнитныйКод);
	КонецЕсли;
	
	ЭтотОбъект.Заголовок = СтрокаЗаголовка;
	ЭтотОбъект.АвтоЗаголовок = Ложь;
	
	СтрокиДерева = ДеревоВыбора.ПолучитьЭлементы();
	
	СтруктураВыбораНомераТелефона = Неопределено;
	СтруктураВыбораАдресаЭП = Неопределено;
	СтруктураВыбораСоздатьКарту = Неопределено;
	Элементы.ТаблицаВыбораЗаписатьНомерТелефона.Видимость = Ложь;
	Элементы.ТаблицаВыбораЗаписатьАдресЭП.Видимость = Ложь;
	Элементы.ТаблицаВыбораСоздатьКарту.Видимость = Ложь;
	
	Для Каждого СтрокаВыбора Из ЗначенияПоиска Цикл
		
		Если СтрокаВыбора.Владелец = Неопределено Тогда
			
			Если СтрокаВыбора.ШаблонШтрихкода = Перечисления.ШаблоныШтрихкодов.Телефон Тогда
				Элементы.ТаблицаВыбораЗаписатьНомерТелефона.Видимость = Истина;
				СтруктураВыбораНомераТелефона = СтрокаВыбора;
			ИначеЕсли СтрокаВыбора.ШаблонШтрихкода = Перечисления.ШаблоныШтрихкодов.АдресЭП Тогда
				Элементы.ТаблицаВыбораЗаписатьАдресЭП.Видимость = Истина;
				СтруктураВыбораАдресаЭП = СтрокаВыбора;
			ИначеЕсли СтрокаВыбора.ШаблонШтрихкода = Перечисления.ШаблоныШтрихкодов.Карта Тогда
				Элементы.ТаблицаВыбораСоздатьКарту.Видимость = Истина;
				СтруктураВыбораСоздатьКарту = СтрокаВыбора;
			КонецЕсли;
		
			Продолжить;
			
		КонецЕсли;
		
		НоваяСтрока = СтрокиДерева.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаВыбора);
		
		Если НЕ НоваяСтрока.ШаблонШтрихкода = Перечисления.ШаблоныШтрихкодов.Телефон
			И НЕ НоваяСтрока.ШаблонШтрихкода = Перечисления.ШаблоныШтрихкодов.АдресЭП
			И НЕ НоваяСтрока.ШаблонШтрихкода = Перечисления.ШаблоныШтрихкодов.НоменклатураВесовой Тогда
			НоваяСтрока.ШаблонШтрихкода = Перечисления.ШаблоныШтрихкодов.ПустаяСсылка();
		КонецЕсли;
		
		НоваяСтрока.ПредставлениеОбъекта =
		"" + СтрокаВыбора.Владелец
		+ ?(ЗначениеЗаполнено(СтрокаВыбора.Характеристика), ", " + СтрокаВыбора.Характеристика , "")
		+ ?(ЗначениеЗаполнено(СтрокаВыбора.Упаковка), ", " + СтрокаВыбора.Упаковка, "");
		
		РаботаСоШтрихкодамиПереопределяемый.ДополнитьСтрокуТаблицыВыбора(НоваяСтрока, СтрокаВыбора);
		
		Если СтрокаВыбора.Свойство("АктивизироватьСтроку") Тогда
			Элементы.ТаблицаВыбора.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.ТаблицаВыбора.ТолькоПросмотр = Истина;
	
	Если ПоказыватьОстатокНоменклатуры Тогда
		ОбновитьОстаткиНоменклатурыВДереве();
	КонецЕсли;
	
	ЭтотОбъект.ТекущийЭлемент = Элементы.ТаблицаВыбора;
	
	МРЦ = 0;
	Если Параметры.Свойство("ПоказатьКолонкуЦена") Тогда
		Элементы.ТаблицаВыбораЦена.Видимость = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("МРЦ", МРЦ) Тогда
		Элементы.ДекорацияПодсказка.Видимость = Истина;
		Элементы.ТаблицаВыбораЦена.Видимость = Истина;
		Элементы.ТаблицаВыбораЦена.Заголовок = СтрШаблон(НСтр("ru = 'Цена  (МРЦ=%1)'"), МРЦ);
		
		Если Элементы.ТаблицаВыбора.ТекущаяСтрока = Неопределено Тогда
			Элементы.ДекорацияПодсказка.Заголовок =
				СтрШаблон(НСтр("ru = 'МРЦ=%1. Отсутствует товар с соответствующей ценой.'"), МРЦ);
		Иначе
			Элементы.ДекорацияПодсказка.Заголовок = СтрШаблон(НСтр("ru = 'МРЦ=%1.'"), МРЦ);
		КонецЕсли;
		
	КонецЕсли;
	
	Параметры.Свойство("ПараметрыШтрихкода", ПараметрыШтрихкода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Элементы.ТаблицаВыбора.ТекущаяСтрока = Неопределено Тогда
		Элементы.ТаблицаВыбора.ТекущаяСтрока = 0;
		Элементы.ТаблицаВыбора.ТекущаяСтрока = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СкладОстатковПриИзменении(Элемент)
	СкладОстатковПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьОстатокНоменклатурыПриИзменении(Элемент)
	ПоказыватьОстатокНоменклатурыПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаВыбора

&НаКлиенте
Процедура ТаблицаВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Закрыть(ПодготовитьСтруктуруВыбора());
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВыбораВыбранаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТаблицаВыбора.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ПодчиненныеСтроки = ТекущаяСтрока.ПолучитьЭлементы();
		Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл
			ПодчиненнаяСтрока.Выбрана = ТекущаяСтрока.Выбрана;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Закрыть(ПодготовитьСтруктуруВыбора());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНомерТелефона(Команда)
	
	Закрыть(ПодготовитьСтруктуруВыбора(СтруктураВыбораНомераТелефона));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьАдресЭП(Команда)
	
	Закрыть(ПодготовитьСтруктуруВыбора(СтруктураВыбораАдресаЭП));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКарту(Команда)
	
	Закрыть(ПодготовитьСтруктуруВыбора(СтруктураВыбораСоздатьКарту));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПодготовитьСтруктуруВыбора(ТекущиеДанные = Неопределено)
	
	СтруктураРезультат = СтруктураДанныхПоиска();
	СтруктураРезультат.НеизвестныеДанныеПО = Ложь;
	СтруктураРезультат.ПараметрыШтрихкода = ПараметрыШтрихкода;
	
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанные = Элементы.ТаблицаВыбора.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		СтруктураСтроки = Новый Структура;
		Если ЗначениеЗаполнено(Штрихкод) Тогда
			СтруктураСтроки.Вставить("Штрихкод", Штрихкод);
			СтруктураСтроки.Вставить("МагнитныйКод", "");
			СтруктураСтроки.Вставить("ДанныеПО", Штрихкод);
			СтруктураРезультат.ДанныеПО = Штрихкод;
			СтруктураРезультат.ТипДанныхПО = "Штрихкод";
		Иначе
			СтруктураСтроки.Вставить("Штрихкод", "");
			СтруктураСтроки.Вставить("МагнитныйКод", МагнитныйКод);
			СтруктураСтроки.Вставить("ДанныеПО", МагнитныйКод);
			СтруктураРезультат.ДанныеПО = МагнитныйКод;
			СтруктураРезультат.ТипДанныхПО = "МагнитныйКод";
		КонецЕсли;
		
		СтруктураСтроки.Вставить("ШаблонШтрихкода", ТекущиеДанные.ШаблонШтрихкода);
		СтруктураСтроки.Вставить("ТипОбъекта", ТекущиеДанные.ТипОбъекта);
		
		СтруктураСтроки.Вставить("Владелец", ТекущиеДанные.Владелец);
		СтруктураСтроки.Вставить("Характеристика", ТекущиеДанные.Характеристика);
		СтруктураСтроки.Вставить("Упаковка", ТекущиеДанные.Упаковка);
		СтруктураСтроки.Вставить("СерияНоменклатуры", ТекущиеДанные.СерияНоменклатуры);
		СтруктураСтроки.Вставить("Количество", ТекущиеДанные.Количество);
		
		Если Не ПараметрыШтрихкода = Неопределено Тогда
			ДанныеМаркировки = ПараметрыШтрихкода.ДанныеМаркировки;
		Иначе
			ДанныеМаркировки = МенеджерОборудованияМаркировкаКлиентСервер.РазобратьШтриховойКодТовара(Штрихкод);
		КонецЕсли;
		
		Если ТипЗнч(ДанныеМаркировки) = Тип("Структура") Тогда
			Если ДанныеМаркировки.Свойство("Разобран") И ДанныеМаркировки.Разобран Тогда
				СтруктураСтроки.Вставить("ДанныеМаркировки", ДанныеМаркировки);
			КонецЕсли;
		КонецЕсли;
		
		Для Каждого ДополнительныйПараметр Из ТекущиеДанные.ДополнительныеДанные Цикл
			СтруктураСтроки.Вставить(ДополнительныйПараметр.Ключ, ДополнительныйПараметр.Значение);
		КонецЦикла;
		
		СтруктураРезультат.ЗначенияПоиска.Добавить(СтруктураСтроки);
		
		ДополнитьСтруктуруДляРегистрацииНовогоОбъекта(СтруктураРезультат);
		
	КонецЕсли;
	
	Возврат СтруктураРезультат;
	
КонецФункции

// Формирует предопределенную структуру,
// Которая используется при поиске по ШК.
//
// Возвращаемое значение:
//  Структура - структура данных поиска.
//
&НаКлиенте
Функция СтруктураДанныхПоиска()
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ЗначенияПоиска", Новый Массив);
	СтруктураПараметров.Вставить("НеизвестныеДанныеПО", Истина);
	СтруктураПараметров.Вставить("ДанныеПО", "");
	СтруктураПараметров.Вставить("ТипДанныхПО", "Штрихкод");
	СтруктураПараметров.Вставить("ПараметрыШтрихкода", Новый Структура);
	
	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервере
Процедура ДополнитьСтруктуруДляРегистрацииНовогоОбъекта(СтруктураПараметров)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("РегистрацияНовойКарты");
	НеизвестныеДанныеПО = Ложь;
	
	РаботаСоШтрихкодамиПереопределяемый.СкорректироватьСтруктуруРезультата(
			СтруктураПараметров,
			Штрихкод,
			СтруктураДействий,
			НеизвестныеДанныеПО,
			Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПоказыватьОстатокНоменклатурыПриИзмененииНаСервере()
	
	Элементы.СкладОстатков.Доступность = ПоказыватьОстатокНоменклатуры;
	Элементы.КолонкиОстатка.Видимость = ПоказыватьОстатокНоменклатуры;
	НастройкиВыбора = Новый Структура;
	НастройкиВыбора.Вставить("ПоказыватьОстатокНоменклатуры", ПоказыватьОстатокНоменклатуры);
	НастройкиВыбора.Вставить("СкладОстатков", СкладОстатков);
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("НастройкиФормыВыбораДанныхПоискаПоШК", "", НастройкиВыбора);
	Если ПоказыватьОстатокНоменклатуры Тогда
		ОбновитьОстаткиНоменклатурыВДереве();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СкладОстатковПриИзмененииНаСервере()
	ОбновитьОстаткиНоменклатурыВДереве();
КонецПроцедуры

&НаСервере
Процедура ОбновитьОстаткиНоменклатурыВДереве()
	
	ТаблицаОстатков = ТаблицаНоменклатурыДляОстатков.Выгрузить();
	ИсходнаяТаблица = ТаблицаНоменклатурыДляОстатков.Выгрузить();
	РаботаСоШтрихкодамиПереопределяемый.ЗаполнитьОстаткиПоСкладу(ИсходнаяТаблица, СкладОстатков, ТаблицаОстатков);
	ТаблицаНоменклатурыДляОстатков.Загрузить(ТаблицаОстатков);
	ОбновитьОстаткиВСтроках();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьОстаткиВСтроках(ТекущаяСтрока = Неопределено)
	
	Если ТекущаяСтрока = Неопределено Тогда
		СтрокиДерева = ДеревоВыбора.ПолучитьЭлементы();
	Иначе
		СтрокиДерева = ТекущаяСтрока.ПолучитьЭлементы();
	КонецЕсли;
	
	Для Каждого ПодчиненнаяСтрока Из СтрокиДерева Цикл
		Если ПодчиненнаяСтрока.ОтображатьОстатки Тогда
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Номенклатура", ПодчиненнаяСтрока.Номенклатура);
			СтруктураПоиска.Вставить("Характеристика", ПодчиненнаяСтрока.Характеристика);
			СтрокиОстатков = ТаблицаНоменклатурыДляОстатков.НайтиСтроки(СтруктураПоиска);
			Для Каждого СтрокаОстатка Из СтрокиОстатков Цикл
				ПодчиненнаяСтрока.Остаток = СтрокаОстатка.Остаток;
				ПодчиненнаяСтрока.Резерв = СтрокаОстатка.Резерв;
				Прервать;
			КонецЦикла;
		КонецЕсли;
		ОбновитьОстаткиВСтроках(ПодчиненнаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуНоменклатурыДляОстатков(ЗначенияПоиска)
	
	Для Каждого СтрокаВыбора Из ЗначенияПоиска Цикл
		Если СтрокаВыбора.Свойство("ОтображатьОстатки") Тогда
			НоваяСтрокаНоменклатуры = ТаблицаНоменклатурыДляОстатков.Добавить();
			НоваяСтрокаНоменклатуры.Номенклатура = СтрокаВыбора.Номенклатура;
			НоваяСтрокаНоменклатуры.Характеристика = СтрокаВыбора.Характеристика;
			НоваяСтрокаНоменклатуры.Упаковка = СтрокаВыбора.Упаковка;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
