
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокЗаполнения = "ВидЭП, Доверенность, Идентификатор, ИдентификаторМП, ИдентификаторЭДО,
	|Имя, ИмяУстройства, ИНН, НомерТелефона, Организация, Отчество, ПолноеИмя,
	|СНИЛС, Фамилия, ФизическоеЛицо, Роль";
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, СписокЗаполнения);
	
	ПолноеИмя = Фамилия + " " + Имя + " " + Отчество;
	
	Элементы.ГруппаВидЭП.Видимость = Ложь;
	
	Элементы.ГруппаДоверенность.Видимость = ЗначениеЗаполнено(ВидЭП) 
			И ВидЭП <> Перечисления.ВидПодписиМПЭПД.НеИспользуется
			И ВидЭП <> Перечисления.ВидПодписиМПЭПД.ПростаяПодпись;
			
	ПредставленияРолейМП = СервисВзаимодействияМПЭПДКлиентСервер.ПредставленияРолейМП();
	Для Каждого КиЗ Из ПредставленияРолейМП Цикл
		Элементы.Роль.СписокВыбора.Добавить(КиЗ.Ключ, КиЗ.Значение);
	КонецЦикла;
			
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	УбратьРеквизиты = Новый Массив;
	ПроверяемыеРеквизиты.Очистить();
	
	ВсеРеквизиты = ПолучитьРеквизиты();
	Для Каждого СтрокаМассива Из ВсеРеквизиты Цикл
		Если СтрокаМассива.СохраняемыеДанные Тогда
			ПроверяемыеРеквизиты.Добавить(СтрокаМассива.Имя);
		КонецЕсли;
	КонецЦикла;
	
	ФорматированныйТелефон = ЗначениеТелефона(НомерТелефона);
	Если СтрДлина(ФорматированныйТелефон) <> 12 Тогда
		ТекстСообщения = НСтр("ru='Телефон должен быть введен полностью и содержать 11 цифр.'");
		Поле = "НомерТелефона";
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
	КонецЕсли;
	
	ПроверяемыеРеквизиты.Добавить("ПредставлениеУчетнойЗаписиЭДО");
	
	УбратьРеквизиты.Добавить("ИНН");
		
	Если ВидЭП = Перечисления.ВидПодписиМПЭПД.НеИспользуется
		Или ВидЭП = Перечисления.ВидПодписиМПЭПД.ПростаяПодпись Тогда
		УбратьРеквизиты.Добавить("Доверенность");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, УбратьРеквизиты);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РольОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Роль", Роль);
	
	РольОткрытие_Завершение = Новый ОписаниеОповещения("РольОткрытие_Завершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ВзаимодействиеМПЭПД.Форма.ВыборРолей", 
		ПараметрыФормы, 
		ЭтотОбъект, 
		УникальныйИдентификатор, , , 
		РольОткрытие_Завершение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	

КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	
	ОкончаниеПодбораСотруднкаСервер(ФизическоеЛицо);
	
КонецПроцедуры

&НаКлиенте
Процедура НомерТелефонаПриИзменении(Элемент)
	
	НомерТелефонаТолькоЦифрыИПрефикс = ЗначениеТелефона(НомерТелефона);
	Если МожноПолучитьПредставлениеТелефона(НомерТелефонаТолькоЦифрыИПрефикс) Тогда
		НомерТелефона = ОбменСГИСЭПДКлиентСервер.ПолучитьПредставлениеТелефона(НомерТелефонаТолькоЦифрыИПрефикс);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	
	ИзменениеФИО();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	
	ИзменениеФИО();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	
	ИзменениеФИО();
	
КонецПроцедуры

&НаКлиенте
Процедура СНИЛСПриИзменении(Элемент)
	
	ЗадавалсяВопросОДубляхПользователя = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	ЗадавалсяВопросОДубляхПользователя = Ложь;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьДанныеНаСервере(Команда)
	
	ЗакрытьПослеИзменения = Ложь;
	ЗапуститьСценарийИзменениеПрофиляПользователя(ЗакрытьПослеИзменения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьИЗакрыть(Команда)
	
	ЗакрытьПослеИзменения = Истина;
	ЗапуститьСценарийИзменениеПрофиляПользователя(ЗакрытьПослеИзменения);
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РольОткрытие_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Роль = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БлокироватьРаботуПользователя(Блокировать)
	
	Элементы.ФормаИзменитьДанныеНаСервере.Доступность = Не Блокировать;
	
КонецПроцедуры

&НаСервере
Процедура ОкончаниеПодбораСотруднкаСервер(Знач СсылкаСправочника)
	
	ДанныеСотрудника = СервисВзаимодействияМПЭПД.ПолучитьДанныеФизическогоЛица(СсылкаСправочника);
	
	ИНН = ДанныеСотрудника.ИНН;
	СНИЛС = ДанныеСотрудника.СтраховойНомерПФР;
	НомерТелефонаТолькоЦифрыИПрефикс = ЗначениеТелефона(ДанныеСотрудника.Телефон);
	Если МожноПолучитьПредставлениеТелефона(НомерТелефонаТолькоЦифрыИПрефикс) Тогда
		НомерТелефона = ОбменСГИСЭПДКлиентСервер.ПолучитьПредставлениеТелефона(НомерТелефонаТолькоЦифрыИПрефикс);
	Иначе
		НомерТелефона = НомерТелефонаТолькоЦифрыИПрефикс;
	КонецЕсли;
	Имя = ДанныеСотрудника.Имя;
	Фамилия = ДанныеСотрудника.Фамилия;
	Отчество = ДанныеСотрудника.Отчество;
	ПолноеИмя = Фамилия + " " + Имя + " " + Отчество;
	
	Если ПустаяСтрока(ИмяУстройства) Тогда
		ИмяУстройства = Фамилия + " " + Имя + " " + Отчество;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеТелефона(Знач ТекущееЗначение)
	
	МаскаПрименена = СтрНачинаетсяС(ТекущееЗначение, "+7");
	
	Результат = "";
	ТолькоСимволы = "0123456789";
	Для Счетчик = 1 По СтрДлина(ТекущееЗначение) Цикл
		ТекСимвол = Сред(ТекущееЗначение, Счетчик, 1);
		Если СтрНайти(ТолькоСимволы, ТекСимвол) > 0 Тогда
			Результат = Результат + ТекСимвол;
		КонецЕсли;
	КонецЦикла;
	
	Если Не МаскаПрименена 
		И Не ПустаяСтрока(Результат)
		И СтрДлина(Результат) = 10 Тогда
		Результат = "7" + Результат;
	КонецЕсли;
	
	Если СтрДлина(Результат) = 11 И Лев(Результат, 1) = "7" Тогда
		Результат = "+" + Результат;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция МожноПолучитьПредставлениеТелефона(Знач Телефон)
	
	ЕстьПлюс = Лев(Телефон, 1) = "+";
	ДлинаТелефона = СтрДлина(Телефон);
	
	Если (ЕстьПлюс И ДлинаТелефона = 12) Или ДлинаТелефона = 11 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#Область АсинхронныеСценарии

&НаКлиенте
Процедура ЗапуститьСценарийИзменениеПрофиляПользователя(ЗакрытьПослеИзменения)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураРезультата = ПроверитьУникальностьДанныхПользователя();
	
	Если СтруктураРезультата.Успешность Тогда
		СценарийИзменениеПрофиляПользователяПродолжение(ЗакрытьПослеИзменения);
	Иначе
		Структура = Новый Структура("ЗакрытьПослеИзменения", ЗакрытьПослеИзменения);
		ОписаниеОповещенияОтвета = Новый ОписаниеОповещения("ВопросОСохраненииНеУникальныхДанныхЗавершение", ЭтотОбъект, Структура);
		СообщениеПользователю = СтруктураРезультата.СообщениеПользователю + Символы.ПС + Символы.ПС + "Сохранить данные текущего мобильного устройства?";
		ПоказатьВопрос(ОписаниеОповещенияОтвета, СообщениеПользователю, РежимДиалогаВопрос.ОКОтмена, , , , ); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОСохраненииНеУникальныхДанныхЗавершение(Результат, ДополнительныеДанные) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		ЗадавалсяВопросОДубляхПользователя = Истина;
		СценарийИзменениеПрофиляПользователяПродолжение(ДополнительныеДанные.ЗакрытьПослеИзменения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СценарийИзменениеПрофиляПользователяПродолжение(ЗакрытьПослеИзменения)
	
	ПараметрыЦикла = Новый Структура;
	ПараметрыЦикла.Вставить("ЭтапЦикла", "Начало");
	ПараметрыЦикла.Вставить("ЗакрытьПослеИзменения", ЗакрытьПослеИзменения);
	
	СервисВзаимодействияМПЭПДКлиент.НачатьАссинхронныйСценарий(Новый ОписаниеОповещения("СценарийИзменениеПрофиляПользователя", ЭтотОбъект, ПараметрыЦикла));
	
КонецПроцедуры

&НаКлиенте
Функция СценарийИзменениеПрофиляПользователя(ОжиданиеРезультата, ПараметрыЦикла) Экспорт
	
	Результат = Истина;
	ЭтапЦикла = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыЦикла, "ЭтапЦикла");
	
	Если ЭтапЦикла = "Начало" Тогда
		ПараметрыЦикла.Вставить("ЭтапЦикла", "ЗакрытьФорму");
		БлокироватьРаботуПользователя(Истина);
		
		Водитель = Новый Структура;
		Водитель.Вставить("ИдентификаторМП", ИдентификаторМП);
		Водитель.Вставить("Наименование", ИмяУстройства);
		Водитель.Вставить("ВидПодписи", ВидЭП);
		Водитель.Вставить("Телефоны", ЗначениеТелефона(НомерТелефона));
		Водитель.Вставить("СНИЛС", СНИЛС);
		Водитель.Вставить("ИНН", ИНН);
		Водитель.Вставить("Роль", Роль);

		Если ЗначениеЗаполнено(Доверенность) Тогда
			Водитель.Вставить("МЧД", Доверенность);
		Иначе
			Водитель.Вставить("МЧД", "");
		КонецЕсли;
		
		ПараметрыФункции = СервисВзаимодействияМПЭПДКлиент.МассивИзЗначений(ИдентификаторЭДО, Водитель);
		СервисВзаимодействияМПЭПДКлиент.НовоеФоновоеЗадание("СервисВзаимодействияМПЭПД.СервисИзменитьВодителя",
			ПараметрыФункции, ПараметрыЦикла, УникальныйИдентификатор);
	КонецЕсли;
	
	Если ЭтапЦикла = "ЗакрытьФорму" Тогда
		Если ОжиданиеРезультата.Статус = "Выполнено" Тогда
			РезультатПроцедуры = ПолучитьИзВременногоХранилища(ОжиданиеРезультата.АдресРезультата);
			Если РезультатПроцедуры <> Истина Тогда
				ПоказатьПредупреждение(, НСтр("ru = 'Не удалось изменить данные пользователя в сервисе взаимодействия с мобильными устройствами.'"));
			Иначе
				Модифицированность = Ложь;
				ОповещенияОбИзмененииПрофиля = СервисВзаимодействияМПЭПДКлиент.ИмяОповещенияОбИзмененииПрофиляПользователяМП();
				СтруктураПолей = СервисВзаимодействияМПЭПДКлиент.СтруктураПолейРегистраПодключенныхМПЭПД();
				ЗаполнитьЗначенияСвойств(СтруктураПолей, ЭтотОбъект);
				СтруктураПолей.Вставить("УникальныйИдентификатор", ВладелецФормы.УникальныйИдентификатор);
				СтруктураПолей.Вставить("ИмяУстройства", ИмяУстройства);
				СтруктураПолей.Вставить("ВидЭП", ВидЭП);
				СтруктураПолей.Вставить("НомерТелефона", НомерТелефона);
				СтруктураПолей.Вставить("Доверенность", Доверенность);
				СтруктураПолей.Вставить("СНИЛС", СНИЛС);
				СтруктураПолей.Вставить("ИНН", ИНН);
				СтруктураПолей.Вставить("ФизическоеЛицо", ФизическоеЛицо);
				СтруктураПолей.Вставить("Фамилия", Фамилия);
				СтруктураПолей.Вставить("Имя", Имя);
				СтруктураПолей.Вставить("Отчество", Отчество);
				СтруктураПолей.Вставить("Роль", Роль);
				
				Оповестить(ОповещенияОбИзмененииПрофиля, СтруктураПолей);
				Если ПараметрыЦикла.ЗакрытьПослеИзменения Тогда
					Закрыть();
				КонецЕсли;
			КонецЕсли;
		Иначе
			ОбщегоНазначенияКлиент.СообщитьПользователю(ОжиданиеРезультата.КраткоеПредставлениеОшибки);
		КонецЕсли;
		БлокироватьРаботуПользователя(Ложь);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НовыйРезультатПроверкиУникальностиДанныхПользователя()
	
	Структура = Новый Структура;
	Структура.Вставить("Успешность", Истина);
	Структура.Вставить("СообщениеПользователю", "");
	Структура.Вставить("СоответствиеПользователей");
	
	Возврат Структура;
	
КонецФункции

&НаСервереБезКонтекста
Функция НоваяСтруктураДляВыбораПользователя()
		
	Структура = Новый Структура;
	Структура.Вставить("Наименование");
	Структура.Вставить("МассивПолей");
	Структура.Вставить("ПоляСтрокой");
	
	Возврат Структура;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроверитьУникальностьДанныхПользователяНаСервере(КлючевыеПоля, Идентификатор, ИдентификаторЭДО)
	
	Результат = НовыйРезультатПроверкиУникальностиДанныхПользователя();
	
	Запрос = Новый Запрос;
	РегистрыСведений.ПодключенныеМПЭПД.ДобавитьВЗапросТекстИПараметрыПоискаПовторяющихсяЗаписей(Запрос,
			КлючевыеПоля, Идентификатор, ИдентификаторЭДО);
			
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	СоответствиеПользователей = Новый Соответствие;
	МетоданныеРесурсов = Метаданные.НайтиПоТипу(Тип("РегистрСведенийКлючЗаписи.ПодключенныеМПЭПД")).Ресурсы;
	МассивПовторяющихсяПолей = Новый Массив;
	
	// Формирование соответствия с уникальными идентификаторами записей и повторяемыми полями
	Пока Выборка.Следующий() Цикл
		Если СоответствиеПользователей[Выборка.Идентификатор] = Неопределено Тогда
			СтруктураДляВыбораПользователя = НоваяСтруктураДляВыбораПользователя();
			СтруктураДляВыбораПользователя.Наименование = Выборка.Наименование;
			СтруктураДляВыбораПользователя.МассивПолей = Новый Массив;
			СоответствиеПользователей.Вставить(Выборка.Идентификатор, СтруктураДляВыбораПользователя);
		КонецЕсли;
		
		СтруктураДляВыбораПользователя = СоответствиеПользователей[Выборка.Идентификатор];
		СинонимРесурса = МетоданныеРесурсов[Выборка.ПолеПоискаПовторений].Синоним;
		СтруктураДляВыбораПользователя.МассивПолей.Добавить(СинонимРесурса);
		
		Если МассивПовторяющихсяПолей.Найти(СинонимРесурса) = Неопределено Тогда
			МассивПовторяющихсяПолей.Добавить(СинонимРесурса);
		КонецЕсли;
		
	КонецЦикла;
	
	// Формирование сообщения для пользователя
	Если МассивПовторяющихсяПолей.Количество() = 1 Тогда
		Шаблон = НСтр("ru = 'По одному из ключевых полей: %1'");
		СписокПолей = МассивПовторяющихсяПолей[0];
		Начало = СтрШаблон(Шаблон, СписокПолей);
	Иначе
		Шаблон = НСтр("ru = 'По ключевым полям: %1'");
		СписокПолей = СтрСоединить(МассивПовторяющихсяПолей, ", ");
		Начало = СтрШаблон(Шаблон, СписокПолей);
	КонецЕсли;
	
	Если СоответствиеПользователей.Количество() = 1 Тогда
		Шаблон = НСтр("ru = ' найдено ранее добавленное мобильное устройство: %1.'");
	Иначе
		Шаблон = НСтр("ru = ' найдены ранее добавленные мобильные устройства.
				|Список устройств: %1.'");
	КонецЕсли;
	
	МассивУстройств = Новый Массив;
	СписокУстройств = "";
	СчетчикЗаписей = 0;
	Для Каждого КлючЗначение Из СоответствиеПользователей Цикл
		
		СтруктураДляВыбораПользователя = КлючЗначение.Значение;
		ПоляСтрокой = СтрСоединить(СтруктураДляВыбораПользователя.МассивПолей, ", ");
		СтруктураДляВыбораПользователя.ПоляСтрокой = ПоляСтрокой;
		
		// Сообщение включает две проименованных записи, дальше добавляется приписка "и еще <количество>"
		СчетчикЗаписей = СчетчикЗаписей + 1;
		Если СчетчикЗаписей < 3 Тогда
			МассивУстройств.Добавить(СтруктураДляВыбораПользователя.Наименование);
			Если СчетчикЗаписей = 2 Тогда
				Если СоответствиеПользователей.Количество() > 2 Тогда
					СписокУстройств = СтрСоединить(МассивУстройств, ", ");
					СписокУстройств = СписокУстройств + " и еще " + СоответствиеПользователей.Количество() - 2;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если СписокУстройств = "" Тогда
		СписокУстройств = СтрСоединить(МассивУстройств, ", ");
	КонецЕсли;
	
	Середина = СтрШаблон(Шаблон, СписокУстройств);
	
	Шаблон = "%1%2";
	СообщениеПользователю = СтрШаблон(Шаблон, Начало, Середина);
	
	Результат.СообщениеПользователю = СообщениеПользователю;
	Результат.СоответствиеПользователей = СоответствиеПользователей;
	Результат.Успешность = Ложь;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПроверитьУникальностьДанныхПользователя()
	
	// Отмена проверки при повторной регистрации и если выопрос уже был задан ранее
	Если ЗадавалсяВопросОДубляхПользователя Тогда
		СтруктураРезультата = НовыйРезультатПроверкиУникальностиДанныхПользователя();
		Возврат СтруктураРезультата;
	КонецЕсли;
	
	КлючевыеПоля = СервисВзаимодействияМПЭПДКлиент.КлючевыеПоляКонтроляПовторенийРегистраПодключенныхМПЭПД();
	ЗаполнитьЗначенияСвойств(КлючевыеПоля, ЭтотОбъект);
	СтруктураРезультата = ПроверитьУникальностьДанныхПользователяНаСервере(КлючевыеПоля,
		Идентификатор, ИдентификаторЭДО);
	
	Возврат СтруктураРезультата;
	
КонецФункции

#КонецОбласти

#Область ИмяУстройства

&НаКлиенте
Процедура ИзменениеФИО()
	
	ПолноеИмя = Фамилия + " " + Имя + " " + Отчество;
	
	СформироватьИмяУстройства();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьИмяУстройства()
	
	ИмяУстройства = ПолноеИмя;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


