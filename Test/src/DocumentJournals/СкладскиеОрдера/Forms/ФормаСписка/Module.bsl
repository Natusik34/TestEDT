#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы
// 
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка) 
	
	УстановитьПодменюПодсистемыПечати();
	
	// Установка способа выбора структурной единицы в зависимости от ФО.
	Если НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимПодразделениям.Получить()
		И НЕ Константы.ФункциональнаяОпцияУчетПоНесколькимСкладам.Получить() Тогда
		
		Элементы.ОтборСклад.РежимВыбораИзСписка = Истина;
		Элементы.ОтборСклад.СписокВыбора.Добавить(Справочники.СтруктурныеЕдиницы.ОсновнойСклад);
		Элементы.ОтборСклад.СписокВыбора.Добавить(Справочники.СтруктурныеЕдиницы.ОсновноеПодразделение);
		
	КонецЕсли;
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(СписокПриходныйОрдер);
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(СписокРасходныйОрдер);
	
	//УНФ.ОтборыСписка
	УстановитьВидимостьОтборов();
	ОпределитьПорядокПредопределенныхОтборовНаСервере();
	ВосстановитьОтборыСписковПриСозданииНаСервере();
	//Конец УНФ.ОтборыСписка
	
	УстановитьФорматДатыСписковПриСозданииНаСервере();
	
	Элементы.ЖурналПодменюЗаполнитьПриходныйОрдер.Видимость = Ложь;
	Элементы.ЖурналПодменюЗаполнитьРасходныйОрдер.Видимость = Ложь;
	
	ТекущаяСтраница = ИмяТекущейСтраницы();
	
	Если Не ТекущаяСтраница = Неопределено Тогда
		
		СтраницаПоИмени = Элементы.Найти(ТекущаяСтраница);
		
		Если Не СтраницаПоИмени = Неопределено Тогда
			Элементы.ГруппаСтраницы.ТекущаяСтраница = СтраницаПоИмени;
		КонецЕсли;
	
	КонецЕсли;
	
	ИспользуемыеВидыУчетаОрдерныхСкладов = СкладскойУчетСервер.ИспользуемыеВидыУчетаОрдерныхСкладов();
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтраницаДокументыКПоступлению", "Видимость", ИспользуемыеВидыУчетаОрдерныхСкладов.УчетОстатковПоПрочимДокументам);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтраницаДокументыКОтгрузке", "Видимость", ИспользуемыеВидыУчетаОрдерныхСкладов.УчетОстатковПоПрочимДокументам);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.ОформитьПриходныйОрдер.КнопкаПоУмолчанию = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "СтраницаДокументыКПоступлению";
	Элементы.СписокДокументыКОтгрузкеСоздатьРасходныйОрдер.КнопкаПоУмолчанию = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "СтраницаДокументыКОтгрузке";
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
		
		СохранитьИмяТекущейСтраницы(); 
		
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтборСкладОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СтруктурнаяЕдиница", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметр) Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	СтруктураПараметров = Новый Структура();
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "СтруктурнаяЕдиница");
	РаботаСФормойДокументаКлиент.ДобавитьПоследнееЗначениеОтбораПоля(ДанныеМеток, СтруктураПараметров, "Организация");
		
	ИмяФормыСтрока = РаботаСФормойДокументаКлиент.ИмяДокументаПоТипу(Параметр);
	ОткрытьФорму("Документ."+ИмяФормыСтрока+".ФормаОбъекта", Новый Структура("ЗначенияЗаполнения",СтруктураПараметров));

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокФинДокументовКПоступлению" Тогда
		Элементы.СписокДокументыКПоступлению.Обновить();
	КонецЕсли;
	
	Если ИмяСобытия = "ОбновитьСписокДокументовКОтгрузке" Тогда
		Элементы.СписокДокументыКОтгрузке.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументыКПоступлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ТекущиеДанные = Элементы.СписокДокументыКПоступлению.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат 
	КонецЕсли;

	ПоказатьЗначение(,ТекущиеДанные.Ссылка);

КонецПроцедуры

&НаКлиенте
Процедура ОтборСкладПриходныйОрдерОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СтруктурнаяЕдиница", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриходныйОрдерОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСкладРасходныйОрдерОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СтруктурнаяЕдиница", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияРасходныйОрдерОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если ТипЗнч(Элемент.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		ПодключитьОбработчикОжидания("УстановитьВидимостьПодменюПоТипуОбъектаСтроки", 0.3, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Элементы.ОформитьПриходныйОрдер.КнопкаПоУмолчанию = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "СтраницаДокументыКПоступлению";
	Элементы.СписокДокументыКОтгрузкеСоздатьРасходныйОрдер.КнопкаПоУмолчанию = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "СтраницаДокументыКОтгрузке";
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументыКОтгрузкеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка) 
	
	ТекущиеДанные = Элементы.СписокДокументыКОтгрузке.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат 
	КонецЕсли;
	
	ПоказатьЗначение(,ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПриходныйОрдер(Команда)
	
	СоздатьДокумент("ПриходныйОрдер");
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьРасходныйОрдер(Команда)
	
	СоздатьДокумент("РасходныйОрдер");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьДокумент(ТипДокумента = "ПриходныйОрдер")
	
	ИмяСписка = ?(ТипДокумента = "ПриходныйОрдер", "СписокДокументыКПоступлению", "СписокДокументыКОтгрузке");
	
	Если Элементы[ИмяСписка].ТекущиеДанные = Неопределено Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'");
		ПоказатьПредупреждение(Неопределено,ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
	
	МассивСтрок = Элементы[ИмяСписка].ВыделенныеСтроки;
	
	МассивДокументов = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из МассивСтрок Цикл
		МассивДокументов.Добавить(Элементы[ИмяСписка].ДанныеСтроки(ВыделеннаяСтрока).Ссылка);
	КонецЦикла;
	
	ИмяФормыДокумента = СтрШаблон(НСтр("ru = 'Документ.%1.ФормаОбъекта'"), ТипДокумента);
	
	Если МассивДокументов.Количество() > 0 Тогда
	
		ТипДокументаПроверки = ?(ТипДокумента = "ПриходныйОрдер", "Приход", "Расход");
		ДанныеФормирирования = ПроверитьКлючевыеРеквизитыДокументов(МассивДокументов, ТипДокументаПроверки);
		
		Если ДанныеФормирирования.СформироватьНесколькоДокументов Тогда

			ТекстСообщения = СтрШаблон(НСтр(
				"ru = 'Выбранные документы содержат различные данные (%1). Сформировать несколько %2 ордеров?'"),
				ДанныеФормирирования.ПредставлениеДанных, ?(ТипДокумента = "ПриходныйОрдер", НСтр("ru = 'Приходных'"), НСтр("ru = 'Расходных'")));
				
			СтруктураПараметровОповещения = Новый Структура();
			СтруктураПараметровОповещения.Вставить("МассивДокументов", МассивДокументов);
			СтруктураПараметровОповещения.Вставить("ИмяСписка", ИмяСписка);
			СтруктураПараметровОповещения.Вставить("ТипДокумента", ТипДокумента);
			СтруктураПараметровОповещения.Вставить("ДанныеФормирирования", ДанныеФормирирования);
			
			ОповещениеПослеВопроса = Новый ОписаниеОповещения("СоздатьДокументЗавершение", ЭтотОбъект, СтруктураПараметровОповещения);
			
			ПоказатьВопрос(ОповещениеПослеВопроса, ТекстСообщения, РежимДиалогаВопрос.ДаНет, 0);

		Иначе
			
			Если МассивДокументов.Количество() Тогда
				
				Если МассивДокументов.Количество() = 1 Тогда
					ОснованиеЗаполнения = Новый Структура("ДанныеЗаполнения, ОткрытеИзАРМ", МассивДокументов[0], Истина);
				Иначе
					ОснованиеЗаполнения = Новый Структура("ДанныеЗаполнения, ОткрытеИзАРМ", МассивДокументов, Истина);
				КонецЕсли;
				
				ПараметрыФормы = Новый Структура("Основание", ОснованиеЗаполнения);
				ОткрытьФорму("Документ." + ТипДокумента + ".Форма.ФормаДокумента", ПараметрыФормы);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	МассивДокументов = ДополнительныеПараметры.МассивДокументов;
	ИмяСписка = ДополнительныеПараметры.ИмяСписка;
	ТипДокумента = ДополнительныеПараметры.ТипДокумента;
	ДанныеФормирирования = ДополнительныеПараметры.ДанныеФормирирования;
	
	Ответ = Результат;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		МассивДокументов = СформироватьОрдераИЗаписать(МассивДокументов, ИмяСписка, ТипДокумента);
		Текст = НСтр("ru='Создание:'");
		Для Каждого СтрокаДокумент Из МассивДокументов Цикл
			
			ПоказатьОповещениеПользователя(Текст, ПолучитьНавигационнуюСсылку(СтрокаДокумент),
				СтрокаДокумент, БиблиотекаКартинок.Информация32);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Элементы[ИмяСписка].Обновить();
	
КонецПроцедуры

&НаСервере
Функция СформироватьОрдераИЗаписать(МассивДокументов, ИмяСписка, ТипДокумента)
	Возврат СкладскойУчетСервер.СформироватьОрдераИЗаписать(МассивДокументов, ТипДокумента);
КонецФункции

&НаСервере
Функция ПроверитьКлючевыеРеквизитыДокументов(МассивДокументов, ТипДокументаПроверки = "Приход")
	
	Возврат СкладскойУчетСервер.ПроверитьКлючевыеРеквизитыДокументов(МассивДокументов, ТипДокументаПроверки);
	
КонецФункции

&НаКлиенте
Процедура ПолучитьПредставлениеПериода(СтандартнаяОбработка)
	ИмяСписка = ИмяСписка();
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, ИмяСписка, "Дата", СтруктураИменПредставленияПериода());
КонецПроцедуры

&НаКлиенте
Функция СтруктураИменПредставленияПериода()
	
	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	
	Если ИмяСтраницы = "СтраницаПриходныйОрдер" Тогда 
		Возврат Новый Структура("ОтборПериод, ПредставлениеПериода", "ОтборПериодПриходныйОрдер", "ПредставлениеПериодаПриходныйОрдер");
	ИначеЕсли ИмяСтраницы = "СтраницаРасходныйОрдер" Тогда
		Возврат Новый Структура("ОтборПериод, ПредставлениеПериода", "ОтборПериодРасходныйОрдер", "ПредставлениеПериодаРасходныйОрдер");
	ИначеЕсли ИмяСтраницы = "СтраницаЖурнал" Тогда 
		Возврат Новый Структура("ОтборПериод, ПредставлениеПериода", "ОтборПериод", "ПредставлениеПериода");
	КонецЕсли;
	
	Возврат Новый Структура("ОтборПериод, ПредставлениеПериода");
	
КонецФункции

&НаКлиенте
Функция ИмяСписка()
	
	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	
	Если ИмяСтраницы = "СтраницаПриходныйОрдер" Тогда Возврат "СписокПриходныйОрдер"
	ИначеЕсли ИмяСтраницы = "СтраницаРасходныйОрдер" Тогда Возврат "СписокРасходныйОрдер"
	ИначеЕсли ИмяСтраницы = "СтраницаЖурнал" Тогда Возврат "Список"
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаСервере
Процедура УстановитьФорматДатыСписковПриСозданииНаСервере()
	
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(Список);
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(СписокПриходныйОрдер);
	ДинамическиеСпискиУНФ.ОтображатьТолькоВремяДляТекущейДаты(СписокРасходныйОрдер);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьОтборыСписковПриСозданииНаСервере()
	
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список, "Список");
	
	СтруктураИменЭлементов = Новый Структура("ФильтрыНастройкиИДопИнфо, ДекорацияРазвернутьОтборы, ПраваяПанель, ОтборПериод, ПредставлениеПериода");
	
	СтруктураИменЭлементов.ФильтрыНастройкиИДопИнфо = "СтраницаПриходныйОрдерФильтрыНастройкиДопИнфо";
	СтруктураИменЭлементов.ДекорацияРазвернутьОтборы = "СтраницаПриходныйОрдерДекорацияРазвернутьОтборы";
	СтруктураИменЭлементов.ПраваяПанель = "СтраницаПриходныйОрдерПраваяПанель";
	СтруктураИменЭлементов.ОтборПериод = "ОтборПериодПриходныйОрдер";
	СтруктураИменЭлементов.ПредставлениеПериода = "ПредставлениеПериодаПриходныйОрдер";
	
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, СписокПриходныйОрдер, "СписокПриходныйОрдер", СтруктураИменЭлементов,,,, "ДанныеМетокПриходныйОрдер",, "ДанныеОтборовПриходныйОрдер", "ГруппаОтборыПриходныйОрдер");
	
	СтруктураИменЭлементов.ФильтрыНастройкиИДопИнфо = "СтраницаРасходныйОрдерФильтрыНастройкиДопИнфо";
	СтруктураИменЭлементов.ДекорацияРазвернутьОтборы = "СтраницаРасходныйОрдерДекорацияРазвернутьОтборы";
	СтруктураИменЭлементов.ПраваяПанель = "СтраницаРасходныйОрдерПраваяПанель";
	СтруктураИменЭлементов.ОтборПериод = "ОтборПериодРасходныйОрдер";
	СтруктураИменЭлементов.ПредставлениеПериода = "ПредставлениеПериодаРасходныйОрдер";
	
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, СписокРасходныйОрдер, "СписокРасходныйОрдер", СтруктураИменЭлементов,,,, "ДанныеМетокРасходныйОрдер",, "ДанныеОтборовРасходныйОрдер", "ГруппаОтборыРасходныйОрдер");

КонецПроцедуры

&НаСервере
Процедура ОпределитьПорядокПредопределенныхОтборовНаСервере()
	
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект);
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект, "ГруппаОтборыПриходныйОрдер", "ПредопределенныеОтборыПоУмолчаниюПриходныйОрдер");
	РаботаСОтборами.ОпределитьПорядокПредопределенныхОтборов(ЭтотОбъект, "ГруппаОтборыРасходныйОрдер", "ПредопределенныеОтборыПоУмолчаниюРасходныйОрдер");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПодменюПодсистемыПечати()
	
	УстановитьПодменюПодсистемыПечатиЖурнала();
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("ДокументСсылка.ПриходныйОрдер"));
	
	ТипИсточника = Новый ОписаниеТипов(Массив);
	
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	
	ПараметрыРазмещения.Источники = ТипИсточника;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКомандыПриходныйОрдер;
	ПараметрыРазмещения.ПрефиксГрупп = "СписокПриходныйОрдер";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.СписокПриходныйОрдерПодменюПечать);
	
	Массив.Очистить();
	Массив.Добавить(Тип("ДокументСсылка.РасходныйОрдер"));
	
	ТипИсточника = Новый ОписаниеТипов(Массив);
	
	ПараметрыРазмещения.Источники = ТипИсточника;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКомандыРасходныйОрдер;
	ПараметрыРазмещения.ПрефиксГрупп = "СписокРасходныйОрдер";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.СписокРасходныйОрдерПодменюПечать);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПодменюПодсистемыПечатиЖурнала()
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("ДокументСсылка.ПриходныйОрдер"));
	
	ТипИсточника = Новый ОписаниеТипов(Массив);
	
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	
	ПараметрыРазмещения.Источники = ТипИсточника;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПараметрыРазмещения.ПрефиксГрупп = "ПриходныйОрдер";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.ПриходныйОрдерПодменюПечать);
	
	Массив.Очистить();
	Массив.Добавить(Тип("ДокументСсылка.РасходныйОрдер"));
	
	ТипИсточника = Новый ОписаниеТипов(Массив);
	
	ПараметрыРазмещения.Источники = ТипИсточника;
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПараметрыРазмещения.ПрефиксГрупп = "РасходныйОрдер";
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	ПечатьДокументовУНФ.УстановитьОтображениеПодменюПечати(Элементы.РасходныйОрдерПодменюПечать);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьПодменюПоТипуОбъектаСтроки()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		
		Элементы.ПриходныйОрдерПодменюПечать.Видимость = Ложь;
		Элементы.РасходныйОрдерПодменюПечать.Видимость = Ложь;
		
		Элементы.ПриходныйОрдерПодменюОтчеты.Видимость = Ложь;
		Элементы.РасходныйОрдерПодменюОтчеты.Видимость = Ложь;
		
		Элементы.ЖурналПодменюЗаполнитьПриходныйОрдер.Видимость = Ложь;
		Элементы.ЖурналПодменюЗаполнитьРасходныйОрдер.Видимость = Ложь;
		
		Возврат
	КонецЕсли;
	
	ЭтоПриходныйОрдер = ТипЗнч(ТекущиеДанные.Ссылка) = Тип("ДокументСсылка.ПриходныйОрдер");
	ЭтоРасходныйОрдер = ТипЗнч(ТекущиеДанные.Ссылка) = Тип("ДокументСсылка.РасходныйОрдер");
	
	ПодчиненныеЭлементыГруппы = Элементы.ГруппаВажныеКоманды.ПодчиненныеЭлементы;
	
	Для Каждого ЭлементМенюПечати Из ПодчиненныеЭлементыГруппы Цикл
		
		Если Не СтрЗаканчиваетсяНа(ЭлементМенюПечати.Имя, "Печать") Тогда 
			Продолжить 
		КонецЕсли;
		
		Элементы.ПриходныйОрдерПодменюПечать.Видимость = ЭтоПриходныйОрдер;
		Элементы.РасходныйОрдерПодменюПечать.Видимость = ЭтоРасходныйОрдер;
		
		Элементы.ЖурналПодменюЗаполнитьПриходныйОрдер.Видимость = ЭтоПриходныйОрдер;
		Элементы.ЖурналПодменюЗаполнитьРасходныйОрдер.Видимость = ЭтоРасходныйОрдер;
		
	КонецЦикла;
	
	ПодчиненныеЭлементыГруппы = Элементы.ГруппаВажныеКоманды.ПодчиненныеЭлементы;
	
	Для Каждого ЭлементМенюПечати Из ПодчиненныеЭлементыГруппы Цикл
		
		Если Не СтрЗаканчиваетсяНа(ЭлементМенюПечати.Имя, "Отчеты") Тогда 
			Продолжить 
		КонецЕсли;
		
		Элементы.ПриходныйОрдерПодменюОтчеты.Видимость = ЭтоПриходныйОрдер;
		Элементы.РасходныйОрдерПодменюОтчеты.Видимость = ЭтоРасходныйОрдер;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьОтборы()
	ИмяГруппы = ПолучитьИмяГруппыПанели();
	НовоеЗначениеВидимость = НЕ Элементы[ИмяГруппы].Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость, СтруктураИменЭлементовПанелиОтборов());
КонецПроцедуры

&НаКлиенте
Функция ПолучитьИмяГруппыПанели()
	
	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	
	Если ИмяСтраницы = "СтраницаПриходныйОрдер" Тогда 
		Возврат "СтраницаПриходныйОрдерФильтрыНастройкиДопИнфо"
	ИначеЕсли ИмяСтраницы = "СтраницаРасходныйОрдер" Тогда 
		Возврат "СтраницаРасходныйОрдерФильтрыНастройкиДопИнфо"
	ИначеЕсли ИмяСтраницы = "СтраницаЖурнал" Тогда 
		Возврат "ФильтрыНастройкиИДопИнфо"
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаКлиенте
Функция СтруктураИменЭлементовПанелиОтборов()
	
	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	
	СтруктураИменПолей = Новый Структура("ФильтрыНастройкиИДопИнфо, ДекорацияРазвернутьОтборы, ПраваяПанель");
	
	Если ИмяСтраницы = "СтраницаПриходныйОрдер" Тогда
		
		СтруктураИменПолей.ФильтрыНастройкиИДопИнфо = "СтраницаПриходныйОрдерФильтрыНастройкиДопИнфо";
		СтруктураИменПолей.ДекорацияРазвернутьОтборы = "СтраницаПриходныйОрдерДекорацияРазвернутьОтборы";
		СтруктураИменПолей.ПраваяПанель = "СтраницаПриходныйОрдерПраваяПанель";
		
		Возврат СтруктураИменПолей;
		
	ИначеЕсли ИмяСтраницы = "СтраницаРасходныйОрдер" Тогда
		
		СтруктураИменПолей.ФильтрыНастройкиИДопИнфо = "СтраницаРасходныйОрдерФильтрыНастройкиДопИнфо";
		СтруктураИменПолей.ДекорацияРазвернутьОтборы = "СтраницаРасходныйОрдерДекорацияРазвернутьОтборы";
		СтруктураИменПолей.ПраваяПанель = "СтраницаРасходныйОрдерПраваяПанель";
		
		Возврат СтруктураИменПолей;

	ИначеЕсли ИмяСтраницы = "СтраницаЖурнал" Тогда 
		
		Возврат Неопределено;

	КонецЕсли;
	
	Возврат СтруктураИменПолей;
	
КонецФункции

&НаСервере
Процедура СохранитьИмяТекущейСтраницы()
	ХранилищеСистемныхНастроек.Сохранить("ЖурналСкладскиеОрдера", "ИмяТекущейСтраницы", Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя);
КонецПроцедуры

&НаСервере
Функция ИмяТекущейСтраницы()
	Возврат ХранилищеСистемныхНастроек.Загрузить("ЖурналСкладскиеОрдера", "ИмяТекущейСтраницы");
КонецФункции

&НаСервере
Функция ИмяСпискаСервер()
	
	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	
	Если ИмяСтраницы = "СтраницаПриходныйОрдер" Тогда Возврат "СписокПриходныйОрдер"
	ИначеЕсли ИмяСтраницы = "СтраницаРасходныйОрдер" Тогда Возврат "СписокРасходныйОрдер"
	ИначеЕсли ИмяСтраницы = "СтраницаЖурнал" Тогда Возврат "Список"
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаСервере
Функция ИмяТчДанныхМетокСервер()
	
	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	
	Если ИмяСтраницы = "СтраницаПриходныйОрдер" Тогда Возврат "ДанныеМетокПриходныйОрдер"
	ИначеЕсли ИмяСтраницы = "СтраницаРасходныйОрдер" Тогда Возврат "ДанныеМетокРасходныйОрдер"
	ИначеЕсли ИмяСтраницы = "СтраницаЖурнал" Тогда Возврат "ДанныеМеток"
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ИмяПанелиМетокОтбора()
	
	ИмяСтраницы = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	
	Если ИмяСтраницы = "СтраницаПриходныйОрдер" Тогда Возврат "СтраницаПриходныйОрдерПраваяПанель"
	ИначеЕсли ИмяСтраницы = "СтраницаРасходныйОрдер" Тогда Возврат "СтраницаРасходныйОрдерПраваяПанель"
	ИначеЕсли ИмяСтраницы = "СтраницаЖурнал" Тогда Возврат "ПраваяПанель"
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ИмяТекущегоСписка = ИмяСписка();
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы[ИмяТекущегоСписка]);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ИмяТекущегоСписка = ИмяСпискаСервер();
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы[ИмяТекущегоСписка], Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ИмяТекущегоСписка = ИмяСписка();
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы[ИмяТекущегоСписка]);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область МеткиОтборов

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения= "" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	ИмяСписка = ИмяСпискаСервер();
	ИмяТчМеток = ИмяТчДанныхМетокСервер();
	
	Если ИмяТчМеток = "ДанныеМетокПриходныйОрдер" Тогда
		ИмяТЧДанныеОтборов = "ДанныеОтборовПриходныйОрдер";
	ИначеЕсли ИмяТчМеток = "ДанныеМетокРасходныйОрдер" Тогда
		ИмяТЧДанныеОтборов = "ДанныеОтборовРасходныйОрдер";
	Иначе
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	КонецЕсли;
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение
											, ПредставлениеЗначения,,,ИмяТчМеток,,,, ИмяТЧДанныеОтборов);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, ЭтотОбъект[ИмяСписка], ИмяПоляОтбораСписка,,,ИмяТчМеток,, ИмяТЧДанныеОтборов);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки,
	СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СмещениеНаименованияМетки = ?(Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "СтраницаЖурнал", 1, 3);
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_") + СмещениеНаименованияМетки);
	
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	ИмяСписка = ИмяСпискаСервер();
	ИмяПравойПанели = ИмяПанелиМетокОтбора();
	
	ПоискМетки = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	Если СтрЗаканчиваетсяНа(ПоискМетки, "ПриходныйОрдер") Тогда
		ИмяТЧДанныеМеток = "ДанныеМетокПриходныйОрдер";
		ИмяТЧДанныеОтборов = "ДанныеОтборовПриходныйОрдер";
	ИначеЕсли СтрЗаканчиваетсяНа(ПоискМетки, "РасходныйОрдер") Тогда
		ИмяТЧДанныеМеток = "ДанныеМетокРасходныйОрдер";
		ИмяТЧДанныеОтборов = "ДанныеОтборовРасходныйОрдер";
	Иначе
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	КонецЕсли;
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, ЭтотОбъект[ИмяСписка], МеткаИД, ИмяСписка, ИмяТЧДанныеМеток,,ИмяПравойПанели,,ИмяТЧДанныеОтборов);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаРасходныйОрдерПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка) 
	ПолучитьПредставлениеПериода(СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура СтраницаПриходныйОрдерПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка) 
	ПолучитьПредставлениеПериода(СтандартнаяОбработка)
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов() 
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект, "Список");
	
	СтруктураИменЭлементов = Новый Структура("ФильтрыНастройкиИДопИнфо, ДекорацияРазвернутьОтборы, ПраваяПанель, ОтборПериод");
	
	СтруктураИменЭлементов.ФильтрыНастройкиИДопИнфо = "СтраницаПриходныйОрдерФильтрыНастройкиДопИнфо";
	СтруктураИменЭлементов.ДекорацияРазвернутьОтборы = "СтраницаПриходныйОрдерДекорацияРазвернутьОтборы";
	СтруктураИменЭлементов.ПраваяПанель = "СтраницаПриходныйОрдерПраваяПанель";
	СтруктураИменЭлементов.ОтборПериод = "ОтборПериодПриходныйОрдер";
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект, "СписокПриходныйОрдер", СтруктураИменЭлементов,,, "ДанныеМетокПриходныйОрдер", "ДанныеОтборовПриходныйОрдер", "ГруппаОтборыПриходныйОрдер");
	
	СтруктураИменЭлементов.ФильтрыНастройкиИДопИнфо = "СтраницаРасходныйОрдерФильтрыНастройкиДопИнфо";
	СтруктураИменЭлементов.ДекорацияРазвернутьОтборы = "СтраницаРасходныйОрдерДекорацияРазвернутьОтборы";
	СтруктураИменЭлементов.ПраваяПанель = "СтраницаРасходныйОрдерПраваяПанель";
	СтруктураИменЭлементов.ОтборПериод = "ОтборПериодРасходныйОрдер";
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект, "СписокРасходныйОрдер", СтруктураИменЭлементов,,, "ДанныеМетокРасходныйОрдер", "ДанныеОтборовРасходныйОрдер", "ГруппаОтборыРасходныйОрдер");
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	СвернутьОтборы() 
КонецПроцедуры

&НаКлиенте
Процедура СтраницаПриходныйОрдерДекорацияРазвернутьОтборыНажатие(Элемент) 
	СвернутьОтборы()
КонецПроцедуры

&НаКлиенте
Процедура СтраницаРасходныйОрдерДекорацияРазвернутьОтборыНажатие(Элемент) 
	СвернутьОтборы()
КонецПроцедуры

&НаКлиенте
Процедура СтраницаПриходныйОрдерСвернутьОтборыНажатие(Элемент) 
	СвернутьОтборы();
КонецПроцедуры

&НаКлиенте
Процедура СтраницаРасходныйОрдерСвернутьОтборыНажатие(Элемент) 
	СвернутьОтборы();
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтборы(Команда)
	
	ИмяМетки = СтрЗаменить(ЭтаФорма.ТекущийЭлемент.Имя, "НастроитьОтборы", "");
	
	ИмяРеквизитаСписка = "Список" + ИмяМетки;
	ИмяТЧДанныеМеток = "ДанныеМеток" + ИмяМетки;
	ИмяТЧДанныеОтборов = "ДанныеОтборов" + ИмяМетки;
	ИмяГруппыОтборов = "ГруппаОтборы" + ИмяМетки;
	ИмяПредопределенныеОтборыПоУмолчанию = "ПредопределенныеОтборыПоУмолчанию" + ИмяМетки;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяРеквизитаСписка", ИмяРеквизитаСписка);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеМеток", ИмяТЧДанныеМеток);
	ДополнительныеПараметры.Вставить("ИмяТЧДанныеОтборов", ИмяТЧДанныеОтборов);
	ДополнительныеПараметры.Вставить("ИмяГруппыОтборов", ИмяГруппыОтборов);
	ДополнительныеПараметры.Вставить("ИмяПредопределенныеОтборыПоУмолчанию", ИмяПредопределенныеОтборыПоУмолчанию);
	
	РаботаСОтборамиКлиент.НастроитьОтборыНажатие(ЭтотОбъект, ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры), ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыСНастройкамиОтборов(ДополнительныеПараметры)
	
	Возврат РаботаСОтборами.ПараметрыДляОткрытияФормыСНастройкамиОтборов(ЭтотОбъект, ДополнительныеПараметры);
	
КонецФункции

&НаКлиенте
Процедура НастройкаОтборовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаОтборовЗавершениеНаСервере(Результат.АдресВыбранныеОтборы, Результат.АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура НастройкаОтборовЗавершениеНаСервере(АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры)
	
	Если ДополнительныеПараметры = Неопределено Тогда
		ИмяРеквизитаСписка = "Список";
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	Иначе
		ИмяРеквизитаСписка = ДополнительныеПараметры.ИмяРеквизитаСписка;
		ИмяТЧДанныеМеток = ДополнительныеПараметры.ИмяТЧДанныеМеток;
		ИмяТЧДанныеОтборов = ДополнительныеПараметры.ИмяТЧДанныеОтборов;
	КонецЕсли;
	
	РаботаСОтборами.НастройкаОтборовЗавершение(ЭтотОбъект, АдресВыбранныеОтборы, АдресУдаленныеОтборы, ДополнительныеПараметры);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборПриИзменении(Элемент)
	
	Подключаемый_ОтборПриИзмененииНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборПриИзмененииНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	ПоискМетки = Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя;
	Если СтрЗаканчиваетсяНа(ПоискМетки, "ПриходныйОрдер") Тогда
		ИмяРеквизитаСписка = "СписокПриходныйОрдер";
		ИмяТЧДанныеМеток = "ДанныеМетокПриходныйОрдер";
		ИмяТЧДанныеОтборов = "ДанныеОтборовПриходныйОрдер";
	ИначеЕсли СтрЗаканчиваетсяНа(ПоискМетки, "РасходныйОрдер") Тогда
		ИмяРеквизитаСписка = "СписокРасходныйОрдер";
		ИмяТЧДанныеМеток = "ДанныеМетокРасходныйОрдер";
		ИмяТЧДанныеОтборов = "ДанныеОтборовРасходныйОрдер";
	Иначе
		ИмяРеквизитаСписка = "Список";
		ИмяТЧДанныеМеток = "ДанныеМеток";
		ИмяТЧДанныеОтборов = "ДанныеОтборов";
	КонецЕсли;
	
	РаботаСОтборами.Подключаемый_ОтборПриИзменении(ЭтотОбъект, ЭлементИмя, ЭлементРодительИмя, ИмяРеквизитаСписка, ИмяТЧДанныеМеток, ИмяТЧДанныеОтборов);
	
КонецПроцедуры

// @skip-warning
&НаКлиенте
Процедура Подключаемый_ОтборОчистка(Элемент)
	
	Подключаемый_ОтборОчисткаНаСервере(Элемент.Имя, Элемент.Родитель.Имя)
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОтборОчисткаНаСервере(ЭлементИмя, ЭлементРодительИмя)
	
	РаботаСОтборами.Подключаемый_ОтборОчистка(ЭтотОбъект, ЭлементИмя);

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОтборов()
	
	Если НЕ ПолучитьФункциональнуюОпцию("УчетПоНесколькимСкладам") Тогда
		Элементы.ОтборСклад.Видимость = Ложь;
		Элементы.ГруппаОтборСклад.Видимость = Ложь;
		
		Элементы.ОтборСкладПриходныйОрдер.Видимость = Ложь;
		Элементы.СтраницаРасходныйОрдерГруппаОтборСклад.Видимость = Ложь;
		
		Элементы.ОтборСкладПриходныйОрдер.Видимость = Ложь;
		Элементы.СтраницаРасходныйОрдерГруппаОтборСклад.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьВсеОтборы(Команда) 
	
	ИмяМетки = СтрЗаменить(ЭтаФорма.ТекущийЭлемент.Имя, "СброситьВсеОтборы", "");
	
	ИмяРеквизитаСписка = "Список" + ИмяМетки;
	ИмяТЧДанныеМеток = "ДанныеМеток" + ИмяМетки;
	ИмяТЧДанныеОтборов = "ДанныеОтборов" + ИмяМетки;
	
	СтруктураИменПредставленияПериода = СтруктураИменПредставленияПериода();
	
	РаботаСОтборамиКлиент.СброситьОтборПоПериоду(ЭтотОбъект, ИмяРеквизитаСписка, "Дата", СтруктураИменПредставленияПериода);
	СброситьВсеМеткиОтбораНаСервере(ИмяРеквизитаСписка, ИмяТЧДанныеМеток, СтруктураИменПредставленияПериода, ИмяТЧДанныеОтборов);
	
КонецПроцедуры

&НаСервере
Процедура СброситьВсеМеткиОтбораНаСервере(ИмяРеквизитаСписка, ИмяТЧДанныеМеток, СтруктураИменПредставленияПериода, ИмяТЧДанныеОтборов) 
	РаботаСОтборами.УдалитьМеткиОтбораСервер(ЭтотОбъект, ЭтаФорма[ИмяРеквизитаСписка],,ИмяРеквизитаСписка, ИмяТЧДанныеМеток, СтруктураИменПредставленияПериода, ИмяТЧДанныеОтборов);
КонецПроцедуры

#КонецОбласти
