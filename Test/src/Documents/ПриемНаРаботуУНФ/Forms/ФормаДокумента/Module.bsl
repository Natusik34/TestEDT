
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ДатаДокумента = Объект.Дата;
	Если Не ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Компания = Константы.УчетПоКомпании.Компания(Объект.Организация);
	ИмяТабличнойЧасти = "Сотрудники";
	ВалютаПоУмолчанию = Константы.НациональнаяВалюта.Получить();
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСовместительство") Тогда
		
		Если Элементы.Найти("СотрудникиСотрудникКод") <> Неопределено Тогда
			
			Элементы.СотрудникиСотрудникКод.Видимость = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Пользователь = Пользователи.ТекущийПользователь();
	
	ЗначениеНастройки = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, "ОсновноеПодразделение");
	ОсновноеПодразделение = ?(ЗначениеЗаполнено(ЗначениеНастройки), ЗначениеНастройки, Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение);
	
	УчетНалогов = ПолучитьФункциональнуюОпцию("ВестиУчетНалогаНаДоходыИВзносов");
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ТекущийСотрудникНалоги", "Видимость", УчетНалогов);
	Если НЕ УчетНалогов Тогда
		
		Элементы.Сотрудники.РасширеннаяПодсказка.Заголовок = 
			НСтр("ru = 'Начисления и удержания указываются на соответствующей странице для каждого сотрудника в отдельности.'");
			
	КонецЕсли;
	
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ПодменюПечать);
	НапоминанияПользователяУНФ.УстановитьОтображениеКомандОрганайзера(Элементы);
	
	ИзменитьОтображениеПодсказки(Элементы, Не ЗначениеЗаполнено(Объект.Ссылка)И ПолучитьФункциональнуюОпцию("ИспользоватьОтчетность"));
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект); 
	
	УстановитьЗначениеДополнительныхРеквизитовТабличныхЧастей();
	
	УстановитьВидимостьВкладок();
	
	УстановитьУсловноеОформлениеФормы();

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	
	Оповестить("ИзменениеПоКадровомуУчету");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_Организации" И Источник = Объект.Организация Тогда
		УстановитьВидимостьВкладок();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьДоступностьПолейСуммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДанныеДляИзмененияДаты = ДокументыУНФКлиент.ДанныеДляИзмененияДаты(ЭтотОбъект, Объект);
	Если ДанныеДляИзмененияДаты.ДатаНеМенялась Тогда
		Возврат;
	КонецЕсли;
	
	ДатаПриИзмененииНаСервере(ДанныеДляИзмененияДаты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыОсновнаяПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.СтраницаНачисленияУдержания
		ИЛИ ТекущаяСтраница = Элементы.СтраницаНалоги Тогда
		
		ЗаполнитьСписокВыбораТекущихСотрудников();
		
		ДанныеТекущейСтроки = Элементы.Сотрудники.ТекущиеДанные;
		
		Если ДанныеТекущейСтроки <> Неопределено Тогда
			
			ТекущийСотрудник = ДанныеТекущейСтроки.ПолучитьИдентификатор();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущийСотрудникНачисленияУдержанияПриИзменении(Элемент)
	
	ИзменитьТекущегоСотрудника();
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияУдержанияСчетЗатратНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаИПерсоналКлиент.ПараметрыВыбораСчетаЗатрат(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущийСотрудникНалогиПриИзменении(Элемент)
	
	ИзменитьТекущегоСотрудника();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриАктивизацииСтроки(Элемент)
	
	ТабличныеЧастиУНФКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НачисленияУдержания");
	ТабличныеЧастиУНФКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НалогиНаДоходы");
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		ТабличныеЧастиУНФКлиент.ДобавитьКлючСвязиВСтрокуТабличнойЧасти(ЭтаФорма);
		ТабличныеЧастиУНФКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НачисленияУдержания");
		ТабличныеЧастиУНФКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НалогиНаДоходы");
		
		СтрокаТабличнойЧасти = Элементы.Сотрудники.ТекущиеДанные;
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СтруктурнаяЕдиница) Тогда
			
			СтрокаТабличнойЧасти.СтруктурнаяЕдиница = ОсновноеПодразделение;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)

	ТабличныеЧастиУНФКлиент.УдалитьСтрокиПодчиненнойТабличнойЧасти(ЭтаФорма, "НачисленияУдержания");
    ТабличныеЧастиУНФКлиент.УдалитьСтрокиПодчиненнойТабличнойЧасти(ЭтаФорма, "НалогиНаДоходы");


КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	
	Элементы.Сотрудники.ТекущиеДанные.ЗанимаемыхСтавок = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияУдержанияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТабличныеЧастиУНФКлиент.ДобавитьКлючСвязиВСтрокуПодчиненнойТабличнойЧасти(ЭтаФорма, Элемент.Имя);
		СтрокаТабличнойЧасти = Элементы.НачисленияУдержания.ТекущиеДанные;
		СтрокаТабличнойЧасти.Валюта = ВалютаПоУмолчанию;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НачисленияУдержанияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если ТабличныеЧастиУНФКлиент.НеВыбранаСтрокаОсновнойТЧ(ЭтаФорма, Элемент.Имя) Тогда
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияУдержанияВидНачисленияУдержанияПриИзменении(Элемент)
	
	ЗарплатаИПерсоналКлиент.СчетЗатратПоУмолчаниюВТекущуюСтроку(ЭтаФорма);
	УстановитьДоступностьПоляСумма();
	
КонецПроцедуры

&НаКлиенте
Процедура НалогиНаДоходыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ТабличныеЧастиУНФКлиент.ДобавитьКлючСвязиВСтрокуПодчиненнойТабличнойЧасти(ЭтаФорма, Элемент.Имя);
		СтрокаТабличнойЧасти = Элементы.НалогиНаДоходы.ТекущиеДанные;
		СтрокаТабличнойЧасти.Валюта = ВалютаПоУмолчанию;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НалогиНаДоходыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если ТабличныеЧастиУНФКлиент.НеВыбранаСтрокаОсновнойТЧ(ЭтаФорма, Элемент.Имя) Тогда
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДекорацияРеквизитыПечатиНажатие(Элемент)
	
	ОткрытьФормуРеквизитыПечати();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЗакрытьПодсказкуНажатие(Элемент)
	
	ИзменитьОтображениеПодсказки(Элементы, Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьИзмененияРеквизитовПечати(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		ПечатьДокументовУНФКлиент.ОбновитьЗначенияРеквизитовПечати(ЭтотОбъект, Результат.ИзмененныеРеквизиты);
		
		Если Результат.Свойство("Команда") Тогда
			
			Подключаемый_ВыполнитьКоманду(Результат.Команда);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьТекущегоСотрудника()
	
	Элементы.Сотрудники.ТекущаяСтрока = ТекущийСотрудник;
	
	#Если МобильныйКлиент Тогда
		
		ТабличныеЧастиУНФКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НачисленияУдержания");
		ТабличныеЧастиУНФКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтаФорма, "НалогиНаДоходы");
		
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ДатаПриИзмененииНаСервере(ДанныеДляИзмененияДаты)
	
	ДокументыУНФ.ДатаПриИзменении(ДанныеДляИзмененияДаты, ЭтотОбъект, Объект);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ДокументыУНФ.ОрганизацияПриИзменении(ЭтотОбъект, Объект);
	УстановитьВидимостьВкладок();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораТекущихСотрудников()
	
	Элементы.ТекущийСотрудникНачисленияУдержания.СписокВыбора.Очистить();
	Элементы.ТекущийСотрудникНалоги.СписокВыбора.Очистить();
	Для каждого СтрокаСотрудник Из Объект.Сотрудники Цикл
		
		ПредставлениеСтроки = СтрШаблон(НСтр("ru = '%1, ТН: %2'"), СтрокаСотрудник.Сотрудник,
			СтрокаСотрудник.Сотрудник.Код); 
		Элементы.ТекущийСотрудникНачисленияУдержания.СписокВыбора.Добавить(СтрокаСотрудник.ПолучитьИдентификатор(),
			ПредставлениеСтроки);
		Элементы.ТекущийСотрудникНалоги.СписокВыбора.Добавить(СтрокаСотрудник.ПолучитьИдентификатор(),
			ПредставлениеСтроки);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьВкладок()
	
	Если Объект.Организация.ИспользуетсяОтчетность Тогда
		Элементы.СтраницаНалоги.Видимость = Ложь;
	Иначе
		Элементы.СтраницаНалоги.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОтображениеПодсказки(Элементы, Показать)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ГруппаПодсказкаАссистента",
		"Видимость",
		Показать);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьПоляСумма()
	
	ТекущиеДанные = Элементы.НачисленияУдержания.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено
		И ЗначениеЗаполнено(ТекущиеДанные.ВидНачисленияУдержания) Тогда
		
		ТекущиеДанные.СуммаЗаблокирована = ПолучитьЗначениеБлокировкиСуммы(ТекущиеДанные.ВидНачисленияУдержания);
		
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура УстановитьЗначениеДополнительныхРеквизитовТабличныхЧастей()
	
	Для каждого СтрокаНачисленийУдержаний Из Объект.НачисленияУдержания Цикл
	
		Если НЕ ЗначениеЗаполнено(СтрокаНачисленийУдержаний.ВидНачисленияУдержания.Формула)
			ИЛИ СтрокаНачисленийУдержаний.ВидНачисленияУдержания.Предопределенный Тогда
			
			СтрокаНачисленийУдержаний.СуммаЗаблокирована = Истина;
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеФормы()
	
	УсловноеОформление.Элементы.Очистить();
	
	НовоеУсловноеОформление = УсловноеОформление.Элементы.Добавить();
	РаботаСФормой.ДобавитьЭлементОтбораКомпоновкиДанных(НовоеУсловноеОформление.Отбор, "Объект.НачисленияУдержания.СуммаЗаблокирована", Истина);
	РаботаСФормой.ДобавитьОформляемоеПоле(НовоеУсловноеОформление, Элементы.НачисленияУдержанияСумма.Имя);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ЦветТекста", ЦветаСтиля.ТекстВторостепеннойНадписи);
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "Текст", НСтр("ru = '<Значение не требуется>'"));
	РаботаСФормой.ДобавитьЭлементУсловногоОформления(НовоеУсловноеОформление, "ТолькоПросмотр", Истина);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначениеБлокировкиСуммы(ВидНачисленияУдержания)
	
	Блокирован = Ложь;
	Если ВидНачисленияУдержания = Справочники.ВидыНачисленийИУдержаний.НалогНаДоходы
		ИЛИ ВидНачисленияУдержания = Справочники.ВидыНачисленийИУдержаний.ПогашениеЗаймаИзЗарплаты
		ИЛИ ВидНачисленияУдержания = Справочники.ВидыНачисленийИУдержаний.ПремияЗаПродажи Тогда
		
		Блокирован = Истина;
		
	КонецЕсли;
	
	Возврат Блокирован;
	
КонецФункции

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

//@skip-check module-unused-method
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
		
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура УстановитьДоступностьПолейСуммы()
	
	Для каждого СтрокаНачисления Из Объект.НачисленияУдержания Цикл
	
		СтрокаНачисления.СуммаЗаблокирована = ПолучитьЗначениеБлокировкиСуммы(СтрокаНачисления.ВидНачисленияУдержания);
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРеквизитыПечати()

	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьИзмененияРеквизитовПечати", ЭтотОбъект);
	ОткрытьФорму("Обработка.РеквизитыПечати.Форма.РеквизитыПечатиПриемНаРаботу", Новый Структура("КонтекстПечати", Объект), ЭтотОбъект, , , , ОписаниеОповещения);
		
КонецПроцедуры 

#КонецОбласти
