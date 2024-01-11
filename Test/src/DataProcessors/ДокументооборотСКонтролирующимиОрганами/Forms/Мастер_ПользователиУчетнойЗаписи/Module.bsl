
#Область ОписаниеПеременных

&НаКлиенте 
Перем КонтекстЭДОКлиент Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Инициализация(Параметры);
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеФормойПриЗапретеИзменения();
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытии_ПослеПолученияКонтекста", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ЭтоЗаписьФизЛица = СтрНайти(ИмяСобытия, "Запись_ФизическиеЛица");
	
	Если ЭтоЗаписьФизЛица Тогда
		МультирежимКлиент.ОбновитьСНИЛСФизЛица(ЭтотОбъект, Параметр);
	КонецЕсли;
	
	ЭтоЗаписьПользователя = СтрНайти(ИмяСобытия, "Запись_Пользователи");
	Если ЭтоЗаписьПользователя Тогда
		ОбновитьПользователя(Источник);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПриПереключенииНаОднопользовательскийРежим(Элемент)
	
	РежимПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ПриПереключенииНаМультиРежим(Элемент)
	
	Текст = НСтр("ru = 'Переход на многопользовательский режим потребует дополнительной оплаты в зависимости от количества подключенных пользователей.'");
	СсылкаНаТарифы = Новый ФорматированнаяСтрока(НСтр("ru = 'Тарифы'"),,,,"https://1c-report.ru/tarifs/rashireniya/69680/");
	
	ТекстВопроса = Новый ФорматированнаяСтрока(Текст, Символы.ПС, СсылкаНаТарифы);
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(1, НСтр("ru = 'Продолжить'"));
	Кнопки.Добавить(2, НСтр("ru = 'Отмена'"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПриПереключенииНаМультиРежим_ПослеОтвета", 
		ЭтотОбъект);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки,,Кнопки[0].Значение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаПользователей

&НаКлиенте
Процедура ТаблицаПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РедактироватьПользователя(Неопределено);
		
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПользователейФлагПриИзменении(Элемент)
	
	ОбработкаЗаявленийАбонентаКлиентСервер.УстановитьМодифицированность(ЭтотОбъект);
	
	Пометка = Элементы.ТаблицаПользователей.ТекущиеДанные.Пометка;
	Строка = ТаблицаПользователей.НайтиПоИдентификатору(Элементы.ТаблицаПользователей.ТекущаяСтрока);

	Если Пометка Тогда
		
		НазначитьПользователюЗначенияПоУмолчанию(Строка);
		УправлениеФормой();
		
	ИначеЕсли ЭтоОтключениеЕдинственногоПодключенногоАдмина(Строка) Тогда
		
		Строка.Пометка = Истина;
		МультирежимКлиент.ПоказатьОшибкуОтключенияЕдинственногоАдмина(КонтекстЭДОКлиент);
		
	ИначеЕсли РекомендоватьОбмен(Строка) Тогда
		
		РекомендоватьВыполнитьОбмен(Строка);
		
	Иначе
		ОчиститьНастройки(Строка.Пользователь);
		УправлениеФормой();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РедактироватьПользователя(Команда)
	
	ТекущиеДанные = Элементы.ТаблицаПользователей.ТекущиеДанные;
	Пользователь  = ТекущиеДанные.Пользователь;
	Если НЕ ТекущиеДанные.Пометка ИЛИ НЕ ЭтоМультиРежим ИЛИ НЕ ОткрытоИзЗаявления Тогда
		ПоказатьЗначение(, Пользователь);
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"РедактироватьПользователя_Завершение", 
		ЭтотОбъект);
		
	МультирежимКлиент.РедактироватьПользователя(ЭтотОбъект, Пользователь, ОписаниеОповещения, Ложь);
	
КонецПроцедуры
	
&НаКлиенте
Процедура УдалитьВсех(Команда)

	Для каждого Строка Из ТаблицаПользователей Цикл
		ОчиститьНастройки(Строка.Пользователь);
	КонецЦикла;
	ОбработкаЗаявленийАбонентаКлиентСервер.УстановитьМодифицированность(ЭтотОбъект);
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВсех(Команда)
	
	Для каждого Строка Из ТаблицаПользователей Цикл
		НазначитьПользователюЗначенияПоУмолчанию(Строка);
	КонецЦикла;
	ОбработкаЗаявленийАбонентаКлиентСервер.УстановитьМодифицированность(ЭтотОбъект);
	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	МастерДалее = Истина;
	МультирежимКлиентСервер.ВладелецЭЦПУказанКорректно(ЭтотОбъект, МастерДалее);
	Если НЕ МастерДалее Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоМультиРежим Тогда
		МультирежимКлиент.ОбновитьРольВладельцаЭЦП(ЭтотОбъект);
	КонецЕсли;
	
	Если НЕ ДанныеУказаныКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьШифровальщиков(ЭтотОбъект);
	Если ЕстьОшибкаШифровальщиков Тогда
		
		МультирежимКлиент.ПоказатьШифровальщиков(ЭтотОбъект);
		Возврат;
		
	КонецЕсли;
	
	РезультатПроверки = ПроверитьАдминовУчетки();
	Если РезультатПроверки.ЕстьОшибка Тогда
		
		ПоказатьПредупреждение(, РезультатПроверки.ТекстОшибки, , НСтр("ru = 'Изменение недоступно'"));
		Возврат;
		
	КонецЕсли;
	
	АдминХочетСтатьПользователем = ЕдинственныйПодключенныйАдминХочетьСтатьПользователем();
	Если АдминХочетСтатьПользователем Тогда
		МультирежимКлиент.ПоказатьОшибкуОтключенияЕдинственногоАдмина(КонтекстЭДОКлиент);
		Возврат;
	КонецЕсли;

	Если ОтключилиМультиРежимСейчас Тогда
		СпроситьПроОтключениеМультирежима();
	Иначе
		ЗакрытьФорму();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьПользователя(Пользователь) Экспорт
	
	Строка = МультирежимКлиентСервер.СтрокаТаблицыПользователей(ЭтотОбъект, Пользователь);
	
	Если Строка = Неопределено 
		ИЛИ ЗначениеЗаполнено(Строка.ФизическоеЛицо) Тогда
		Возврат;
	КонецЕсли;
	
	ФизЛицо = МультирежимВызовСервера.ФизЛицоПоПользователюИзСправочникаПользователи(Пользователь);
	
	Если ЗначениеЗаполнено(ФизЛицо) Тогда
		Строка.ФизическоеЛицо = ФизЛицо;
		МультирежимКлиент.ОбновитьСНИЛСФизЛица(ЭтотОбъект, ФизЛицо);
		ЗаполнитьРасчитываемыеНастройкиПользователя(Пользователь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьШифровальщиков(Форма)
	
	РезультатПроверки = МультирежимКлиентСервер.ПроверитьШифровальщиковФНС(
		Форма,
		Истина,
		Ложь);
		
	Форма.ЕстьОшибкаШифровальщиков = РезультатПроверки.ЕстьОшибка;
	
КонецПроцедуры

&НаСервере
Функция АдресТаблицы(Имя) Экспорт

	Возврат Мультирежим.АдресТаблицы(ЭтотОбъект, Имя);

КонецФункции

&НаКлиенте
Функция ЭтоОтключениеЕдинственногоПодключенногоАдмина(Строка) Экспорт
	
	Админы = МультирежимКлиентСервер.ПодключенныеАдминистраторыПоТаблице(ЭтотОбъект);
	ЭтоРазрегистрация  = МультирежимКлиентСервер.ЭтоРазрегистрация(ЭтотОбъект, Строка);
	ЭтоЛичныеНастройки = МультирежимКлиентСервер.ЭтоЛичныеНастройки(ЭтотОбъект, Строка);
	
	БылЕдинственнымАдмином = 
		ЭтоМультиРежим
		И Админы.Количество() = 0 
		И ЭтоРазрегистрация
		И ВладелецЭЦПЭтоАдмин
		И НЕ Строка.ЭтоПотенциальныйПользователь
		И ЭтоЛичныеНастройки;
	
	Возврат БылЕдинственнымАдмином;
	
КонецФункции

&НаКлиенте
Функция ЕдинственныйПодключенныйАдминХочетьСтатьПользователем() Экспорт
	
	Строка = МультирежимКлиентСервер.СтрокаТаблицыПользователей(ЭтотОбъект, ТекущийПользователь);
	ОсталосьАдминов = МультирежимКлиентСервер.ПодключенныеАдминистраторыПоТаблице(ЭтотОбъект, Истина).Количество();
	
	БылЕдинственнымАдмином = 
		ЭтоМультиРежим
		И ОсталосьАдминов = 0
		И НЕ Строка.ЭтоПотенциальныйПользователь
		И МультирежимКлиентСервер.ЭтоЛичныеНастройки(ЭтотОбъект, Строка)
		И МультирежимКлиентСервер.БылАдминомСталПользователем(ЭтотОбъект, ТекущийПользователь);
	
	Возврат БылЕдинственнымАдмином;
	
КонецФункции

&НаКлиенте
Функция РекомендоватьОбмен(Строка)
	
	РекомендоватьОбмен = 
		НЕ Строка.Пометка
		И ЭтоМультиРежим 
		И ВладелецЭЦПЭтоАдмин 
		И НЕ Строка.ЭтоПотенциальныйПользователь
		И Строка.ПометкаИсходная;
		
	Возврат РекомендоватьОбмен;
	
КонецФункции

&НаКлиенте
Процедура РекомендоватьВыполнитьОбмен(Строка)

	ОписаниеОповещения = Новый ОписаниеОповещения(
		"РекомендоватьВыполнитьОбмен_ПослеОтвета", 
		ЭтотОбъект);

	ЭтоЛичныеНастройки = МультирежимКлиентСервер.ЭтоЛичныеНастройки(ЭтотОбъект, Строка);
	Если ЭтоЛичныеНастройки И ВладелецЭЦПЭтоАдмин Тогда
		Форма = КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.Мастер_РекомендацияВыполнитьОбменАдмину";
	Иначе
		Форма = КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.Мастер_РекомендацияВыполнитьОбменПользователю";
	КонецЕсли;
		
	ОткрытьФорму(Форма,,,,,,ОписаниеОповещения);

КонецПроцедуры
	
&НаКлиенте
Процедура РекомендоватьВыполнитьОбмен_ПослеОтвета(Ответ, ВходящийКонтекст) Экспорт
	
	Строка = ТаблицаПользователей.НайтиПоИдентификатору(Элементы.ТаблицаПользователей.ТекущаяСтрока);

	Если Ответ = "Отмена" Тогда
		Строка.Пометка = Истина;
	ИначеЕсли Ответ = "Выполнить обмен" Тогда
		ВыполнитьОбмен();
	Иначе
		ОчиститьНастройки(Строка.Пользователь);
		УправлениеФормой();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен() Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВыполнитьОбменЗавершение", 
		ЭтотОбъект);
		
	ДокументооборотСКОКлиент.ВыполнитьОбмен(ЭтотОбъект, ОписаниеОповещения, Организация);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбменЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура СпроситьПроОтключениеМультирежима()

	ОписаниеОповещения = Новый ОписаниеОповещения(
		"СпроситьПроОтключениеМультирежима_ПослеОтвета", 
		ЭтотОбъект);

	ОткрытьФорму(
		КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.Мастер_ВопросОтключитьМультирежим",
		,,,,,
		ОписаниеОповещения);

КонецПроцедуры
	
&НаКлиенте
Процедура СпроситьПроОтключениеМультирежима_ПослеОтвета(Ответ, ВходящийКонтекст) Экспорт
	
	Если Ответ = "Отключить многопользовательский режим" Тогда
		ЗакрытьФорму();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	
	ДополнительныеПараметры = ПараметрыЗакрытия();
	Модифицированность = Ложь;
	
	Закрыть(ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Функция ПроверитьАдминовУчетки()
	
	РезультатПроверки = Мультирежим.ПроверитьАдминовУчетки(ЭтотОбъект, Истина, Ложь);
	Возврат РезультатПроверки;
	
КонецФункции

&НаСервере
Функция ПараметрыЗакрытия()
	
	ДополнительныеПараметры = Новый Структура(ПараметрыФормы);
	ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, ЭтотОбъект, ПараметрыФормы);
	
	ДополнительныеПараметры.Вставить("ПараметрыФормы", 		ПараметрыФормы);
	ДополнительныеПараметры.Вставить("Модифицированность", 	Модифицированность);
	ДополнительныеПараметры.Вставить("АдресТаблицы",   		АдресТаблицыПользователей());
	ДополнительныеПараметры.Вставить("ВсеГосОрганыУчетнойЗаписи", ВсеГосОрганыУчетнойЗаписи);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии_ПослеПолученияКонтекста(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаСервере
Функция АдресТаблицыПользователей() Экспорт
	
	Возврат Мультирежим.АдресТаблицы(ЭтотОбъект, "ТаблицаПользователей");
	
КонецФункции	

&НаСервере
Функция ДанныеУказаныКорректно()
	
	ДанныеКорректные = Истина;
	
	Мультирежим.ПроверитьПользователей(
		ЭтотОбъект, 
		ДанныеКорректные,
		,
		Ложь,
		Ложь);
	
	Возврат ДанныеКорректные;
	
КонецФункции

&НаСервере
Процедура Инициализация(Параметры)
	
	ПараметрыФормы = Параметры.ПараметрыФормы;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, ПараметрыФормы);
	ТипЗаявления = Параметры.ТипЗаявления;
	
	ОткрытоИзЗаявления = Параметры.ОткрытоИзЗаявления;
	Если НЕ ОткрытоИзЗаявления Тогда
		ЗапретитьИзменение = Истина;
	КонецЕсли;
	
	ТаблицаИзАдреса(Параметры.АдресТаблицы, "ТаблицаПользователей");
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	УчетнаяЗапись = КонтекстЭДОСервер.УчетнаяЗаписьОрганизации(Организация);
	
	ВсеГосОрганыУчетнойЗаписи = Параметры.ВсеГосОрганыУчетнойЗаписи;
	
	ЗаполнитьРасчитываемыеНастройки();
	
	ТаблицаПользователей.Сортировать("Порядок");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРасчитываемыеНастройки()
	
	Для каждого Строка Из ТаблицаПользователей Цикл
		ЗаполнитьРасчитываемыеНастройкиПользователя(Строка.Пользователь);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРасчитываемыеНастройки_ГосОрганы(Строка) Экспорт
	
	Строка.ГосОрганы = МультирежимКлиентСервер.ГосОрганыДляСравнения(Строка);
	
	// ГосОрганыПредставление
	Если ЗапретитьИзменение Тогда
		Строка.ГосОрганыПредставление = Строка.ГосОрганы;
	Иначе
		Строка.ГосОрганыПредставление = Мультирежим.ОформлениеНаправленийПользователя(ЭтотОбъект, Строка).Заголовок;
	КонецЕсли;
	
	// СоставГосОрганов
	Если Строка.ЕстьДоступКоВсемГосОрганам Тогда
		Строка.СоставГосОрганов  = НСтр("ru = 'Как в учетной записи'");
	Иначе
		Строка.СоставГосОрганов  = НСтр("ru = 'Произвольный'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРасчитываемыеНастройкиПользователя(Пользователь) Экспорт
	
	ПроверитьШифровальщиков(ЭтотОбъект);
	
	Строка = МультирежимКлиентСервер.СтрокаТаблицыПользователей(ЭтотОбъект, Пользователь);
	
	Если Строка.Пометка Тогда
		
		ЗаполнитьРасчитываемыеНастройки_ГосОрганы(Строка);
		
		Строка.РольПредставление  = МультирежимКлиентСервер.РольПользователя(Строка);
		
		Если Строка.ФизическоеЛицо = Руководитель Тогда
			Строка.ВладелецЭЦПТип = ПредопределенноеЗначение("Перечисление.ТипыВладельцевЭЦП.Руководитель");
		Иначе
			Строка.ВладелецЭЦПТип = ПредопределенноеЗначение("Перечисление.ТипыВладельцевЭЦП.ДругойСотрудник");
		КонецЕсли;
		
	Иначе
		Строка.ГосОрганыПредставление = "";
		Строка.ГосОрганы = "";
		Строка.СоставГосОрганов = "";
		Строка.РольПредставление = "";
		Строка.ВладелецЭЦПТип  = Неопределено;
	КонецЕсли;
	
	Строка.Порядок = ПорядокПользователей(Строка);
	Строка.ПользовательПредставление = Мультирежим.ПредставлениеПользователей(ЭтотОбъект, Строка);
	
	ЗаполнитьФизЛицо = 
		НЕ ЗначениеЗаполнено(Строка.ФизическоеЛицо) 
		И ЭтоМультиРежим
		И Строка.Пометка;
		
	Если ЗаполнитьФизЛицо Тогда
		Строка.Картинка = БиблиотекаКартинок.ПользовательБезНеобходимыхСвойств;
	Иначе
		Строка.Картинка = БиблиотекаКартинок.Пользователь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПорядокПользователей(Сведения)

	Если Сведения.Пользователь = ТекущийПользователь Тогда
		Возврат 1;
	ИначеЕсли Сведения.ФизическоеЛицо = Руководитель Тогда
		Возврат 2;
	Иначе
		Возврат 3;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ТаблицаИзАдреса(Адрес, Имя) Экспорт
	
	Мультирежим.ТаблицаИзАдреса(ЭтотОбъект, Адрес, Имя);
	
КонецПроцедуры

&НаСервере
Процедура РежимПриИзмененииНаСервере()
	
	ОбработкаЗаявленийАбонентаКлиентСервер.УстановитьМодифицированность(ЭтотОбъект);

	Если ЭтоМультиРежим Тогда
		ОтключилиМультиРежимСейчас = Ложь;
		ДобавитьПометки();
		ИнициализироватьТаблицуПользователейВМультиРежиме();
		ВладелецЭЦПЭтоАдмин = МультирежимКлиентСервер.ВладелецЭЦПЭтоАдмин(ЭтотОбъект);
	Иначе
		Если ЭтоМультиРежимИсходный Тогда
			ОтключилиМультиРежимСейчас = Истина;
		КонецЕсли;
		ПеревестиТаблицуВОднопользовательскийРежим();
	КонецЕсли;
	
	МультирежимКлиентСервер.ОбновитьВсеГосОрганыУчетнойЗаписи(ЭтотОбъект, "ЭтоМультиРежим");
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПометки()
	
	Для каждого Строка Из ТаблицаПользователей Цикл
		
		Если Мультирежим.ЭтоОбязательныйАдмин(ЭтотОбъект, Строка) Тогда
			Строка.Пометка = Истина;
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПеревестиТаблицуВОднопользовательскийРежим()
	
	ВладелецЭЦПЭтоАдмин = Ложь;
	
	Для каждого Строка Из ТаблицаПользователей Цикл
		ЗаполнитьРасчитываемыеНастройкиПользователя(Строка.Пользователь);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьТаблицуПользователейВМультиРежиме()
	
	ВладелецЭЦПЭтоАдмин = Истина;

	Для каждого Строка Из ТаблицаПользователей Цикл
		Если Строка.Пометка Тогда
			НазначитьПользователюЗначенияПоУмолчаниюНаСервере(Строка.Пользователь);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой() Экспорт

	Элементы.ТаблицаПользователейРольПредставление.Видимость = ЭтоМультиРежим;
	Элементы.ТаблицаПользователейГосОрганыПредставление.Видимость = ЭтоМультиРежим;
	Элементы.ТаблицаПользователейПолучательФНС.Видимость = ЭтоМультиРежим;	
	Элементы.ТаблицаПользователейСоставГосОрганов.Видимость = ЭтоМультиРежим;
	
	//Элементы.ГруппаФиксацииШирины.Ширина = 1;
	Элементы.Подсказка.Видимость = ЭтоМультиРежим;
	
	Если ЭтоМультиРежим Тогда
		Элементы.ТаблицаПользователейПользовательПредставление.РастягиватьПоГоризонтали = Истина;
		Элементы.ПояснениеКТаблице.Заголовок = НСтр("ru = 'Отметьте пользователей, у которых будет доступ к учетной записи, и укажите доступные им гос. органы.
                                                     |Изменения будут выделены желтым. '");
	Иначе
		Элементы.ТаблицаПользователейПользовательПредставление.РастягиватьПоГоризонтали = Неопределено;
		Элементы.ПояснениеКТаблице.Заголовок = НСтр("ru = 'Отметьте пользователей, включая Вас, которые будут иметь доступ к учетной записи.'");
	КонецЕсли;
	
	Заголовок = СтрШаблон(НСтр("ru = 'Пользователи учетной записи (%1)'"), Строка(Организация));
	
	Элементы.РедактироватьПользователя.Видимость = ЭтоМультиРежим;
	
	Элементы.ГруппаШапка.Видимость = ПоддерживаетсяМультирежим;
	
	ИзменитьОформлениеИтога();
	
	ЗаполнитьРасчитываемыеНастройки();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормойПриЗапретеИзменения()

	Элементы.ГруппаШапка.ТолькоПросмотр = ЗапретитьИзменение;
	Элементы.КнопкиТаблицы.Видимость = НЕ ЗапретитьИзменение;
	ЭтотОбъект.КоманднаяПанель.Видимость = НЕ ЗапретитьИзменение;
	Элементы.ТаблицаПользователейНастроен.ТолькоПросмотр = ЗапретитьИзменение;
	Элементы.ПояснениеКТаблице.Видимость = ОткрытоИзЗаявления;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеИтога()

	// Выбраны 5 из 7 пользователей
	
	Отбор = Новый Структура();
	Отбор.Вставить("Пометка", Истина);
	НайденныеСтроки = ТаблицаПользователей.НайтиСтроки(Отбор);
	
	ШаблонВсего = ";%1 пользователя;;%1 пользователей;%1 пользователей;%1 пользователей";
	ПредставлениеВсего = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ШаблонВсего, ТаблицаПользователей.Количество());
	
	ШаблонВыбрано = ";Выбран %1;;Выбраны %1;Выбраны %1;Выбрано %1";
	ПредставлениеВыбрано = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(ШаблонВыбрано, НайденныеСтроки.Количество());
	
	Представление = ПредставлениеВыбрано + НСтр("ru = ' из '") + ПредставлениеВсего;
	
	Элементы.ИтогПоТаблице.Заголовок = Представление;
		
КонецПроцедуры

&НаКлиенте
Процедура НазначитьПользователюЗначенияПоУмолчанию(Строка)
	
	Если ЭтоМультиРежим Тогда
		НазначитьПользователюЗначенияПоУмолчаниюНаСервере(Строка.Пользователь);
	Иначе
		Строка.Пометка = Истина;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура НазначитьПользователюЗначенияПоУмолчаниюНаСервере(Пользователь)
	
	Мультирежим.ИнициализироватьПользователяМультиРежима(ЭтотОбъект, Пользователь);
	ЗаполнитьРасчитываемыеНастройкиПользователя(Пользователь);
		
КонецПроцедуры

&НаСервере
Процедура ОчиститьНастройки(Пользователь)
	
	Мультирежим.ОчиститьПраваПользователя(ЭтотОбъект, Пользователь);
	
	Если МультирежимКлиентСервер.ЭтоСаморазрегистрацияАдмина(ЭтотОбъект) Тогда
		Строка = МультирежимКлиентСервер.СтрокаТаблицыПользователей(ЭтотОбъект, Пользователь);
		Строка.ЭтоАдмин = Истина;
	КонецЕсли;

	ЗаполнитьРасчитываемыеНастройкиПользователя(Пользователь);
	
КонецПроцедуры
	
&НаСервере
Функция ПараметрыФормыПравПользователя() Экспорт
	
	Результат = Мультирежим.ПараметрыФормыПравПользователя(ЭтотОбъект);
	Результат.Вставить("ТипЗаявления", ТипЗаявления);
	
	Возврат Результат;
	
КонецФункции
	
&НаКлиенте
Процедура РедактироватьПользователя_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	ЗаполнитьРасчитываемыеНастройки();
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьШифровальщиков(АдресТаблицы) Экспорт
	
	Мультирежим.СкопироватьШифровальщиков(ЭтотОбъект, АдресТаблицы);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыШифровальщики() Экспорт
	
	Возврат Мультирежим.ПараметрыФормыШифровальщики(ЭтотОбъект);
	
КонецФункции

&НаСервере
Процедура СкорректироватьПризнакЕстьДоступКоВсемГосОрганам() Экспорт

	Мультирежим.СкорректироватьПризнакЕстьДоступКоВсемГосОрганам(ЭтотОбъект, ВсеГосОрганыУчетнойЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПереключенииНаМультиРежим_ПослеОтвета(Ответ, ВходящийКонтекст) Экспорт
	
	Если Ответ = 1 Тогда
		РежимПриИзмененииНаСервере();
	Иначе
		ЭтоМультиРежим = 0;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
