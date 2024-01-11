///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ПодборФИО".
// ОбщийМодуль.ПодборФИО.
//
// Серверные процедуры работы с классификатором ФИО:
//  - возврат значений классификатора ФИО по переданным параметрам поиска;
//  - возврат идентификатора классификатора;
//  - процедуры загрузки, добавления и обновления классификатора;
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает результат поиска по классификатору, пустой массив если данные не найдены.
//
// Параметры:
//  РежимПоиска - Строка - Режим поиска значения по классификатору, может принимать следующие значения:
//    "Фамилия", "Имя", "Отчество", "ФИО".
//  ДанныеФИО - Структура, Неопределено - описывает данные ФИО, по которым будет выполняться поиск.
//    В случае если значение параметра "Пол" пустое, будет использована для его определения по данным классификатора:
//    * Фамилия - Строка, Неопределено - описывает фамилию лица (ее часть когда РежимПоиска = "Фамилия").
//      Свойство может не передаваться.
//    * Имя - Строка, Неопределено - описывает имя лица (его часть когда РежимПоиска = "Имя").
//      Свойство может не передаваться.
//    * Отчество - Строка, Неопределено - описывает отчество лица (его часть когда РежимПоиска = "Отчество").
//      Свойство может не передаваться.
//    * Представление - Строка - описывает ФИО лица (в тех случаях когда РежимПоиска = "ФИО").
//      Свойство может не передаваться.
//  Пол - Число - задает значение пола для поиска значения в классификаторе, может принимать значения:
//    0 - не задан(будет определен по данным структуры ДанныеФИО), 1- мужской, 2 - женский, 3 - допустимы оба.
//  РазмерВыборки - Число - определяет размер выборки данных классификатора.
// Возвращаемое значение:
//   Массив из Строка - данные поиска по классификатору, отсортированные по популярности.
//
Функция Подобрать(РежимПоиска, ДанныеФИО = Неопределено, Пол = 0, РазмерВыборки = 10) Экспорт
	
	ВидДанных           = РежимПоиска;
	ДанныеФИОДляПоиска  = НовыйДанныеФИОДляПоиска(ДанныеФИО);
	ДанныеПредставления = Новый Массив;
	
	Если ВидДанных = "ФИО" Тогда
		ПодготовитьДанныеПоискаПоПредставлению(ДанныеФИОДляПоиска, ДанныеПредставления, ВидДанных);
	КонецЕсли;
	
	Если Пол = 0 Тогда
		Пол = ОпределитьПолПоВведеннымДанным(ВидДанных, ДанныеФИОДляПоиска);
	КонецЕсли;
	
	Если ДанныеФИО = Неопределено Тогда
		ТекстДляАвтоПодбора = "";
	Иначе
		ТекстДляАвтоПодбора = ДанныеФИОДляПоиска[ВидДанных];
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КлассификаторФИО.Значение КАК Значение
	|ИЗ
	|	РегистрСведений.КлассификаторФИО КАК КлассификаторФИО
	|ГДЕ
	|	КлассификаторФИО.ВидДанных = &ВидДанных
	|	И КлассификаторФИО.Значение ПОДОБНО &НачалоТекста
	|	И &УсловиеПола
	|
	|УПОРЯДОЧИТЬ ПО
	|	КлассификаторФИО.ПриоритетОтображения УБЫВ";

	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"ВЫБРАТЬ",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ВЫБРАТЬ ПЕРВЫЕ %1", РазмерВыборки));
		
	Если Пол = 3 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПола", "ИСТИНА");
	Иначе
		Запрос.Текст = СтрЗаменить(
			Запрос.Текст,
			"&УсловиеПола",
			"(КлассификаторФИО.Пол = &Пол ИЛИ КлассификаторФИО.Пол = 3)");
		Запрос.УстановитьПараметр("Пол", Пол);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НачалоТекста", ТекстДляАвтоПодбора + "%");
	Запрос.УстановитьПараметр("ВидДанных",    Перечисления.ВидДанныхФИО[ВидДанных]);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДанныеПоиска = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		Если РежимПоиска = "ФИО" Тогда
			ДанныеПредставления[ДанныеПредставления.Количество()-1] = Выборка.Значение;
			ДанныеПоиска.Добавить(СтрСоединить(ДанныеПредставления, " "));
		Иначе
			ДанныеПоиска.Добавить(Выборка.Значение);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДанныеПоиска;
	
КонецФункции

// Возвращает результат определения пола по данным классификатора.
//
// Параметры:
//  ДанныеФИО - Структура, Неопределено - описывает данные ФИО, по которым будет выполняться поиск.
//  Если передано свойство "Представление", поиск будет выполнятся по нему.
//    * Фамилия - Строка - описывает фамилию лица (ее часть когда РежимПоиска = "Фамилия").
//      Свойство может не передаваться.
//    * Имя - Строка - описывает имя лица (его часть когда РежимПоиска = "Имя").
//      Свойство может не передаваться.
//    * Отчество - Строка - описывает отчество лица (его часть когда РежимПоиска = "Отчество").
//      Свойство может не передаваться.
//    * Представление - Строка - описывает ФИО лица (в тех случаях когда РежимПоиска = "ФИО").
//      Свойство может не передаваться.
//  Возвращаемое значение:
//    Число - значение пола по данным классификатора, может принимать значения:
//      1- мужской, 2 - женский, 3 - допустимы оба.
//
Функция ОпределитьПол(ДанныеФИО) Экспорт
	
	ДанныеФИОДляПоиска = НовыйДанныеФИОДляПоиска(ДанныеФИО);
	
	Если ЗначениеЗаполнено(ДанныеФИОДляПоиска.Представление) Тогда
		ПодготовитьДанныеПоискаПоПредставлению(ДанныеФИОДляПоиска);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПолПоФамилии.Пол КАК Пол
	|ПОМЕСТИТЬ ДанныеПола
	|ИЗ
	|	РегистрСведений.КлассификаторФИО КАК ПолПоФамилии
	|ГДЕ
	|	ПолПоФамилии.ВидДанных = ЗНАЧЕНИЕ(Перечисление.ВидДанныхФИО.Фамилия)
	|	И ПолПоФамилии.Значение = &Фамилия
	|	И (ПолПоФамилии.Пол = 1
	|			ИЛИ ПолПоФамилии.Пол = 2)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПолПоИмени.Пол
	|ИЗ
	|	РегистрСведений.КлассификаторФИО КАК ПолПоИмени
	|ГДЕ
	|	ПолПоИмени.ВидДанных = ЗНАЧЕНИЕ(Перечисление.ВидДанныхФИО.Имя)
	|	И ПолПоИмени.Значение = &Имя
	|	И (ПолПоИмени.Пол = 1
	|			ИЛИ ПолПоИмени.Пол = 2)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПолПоОтчеству.Пол
	|ИЗ
	|	РегистрСведений.КлассификаторФИО КАК ПолПоОтчеству
	|ГДЕ
	|	ПолПоОтчеству.ВидДанных = ЗНАЧЕНИЕ(Перечисление.ВидДанныхФИО.Отчество)
	|	И ПолПоОтчеству.Значение = &Отчество
	|	И (ПолПоОтчеству.Пол = 1
	|			ИЛИ ПолПоОтчеству.Пол = 2)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеПола.Пол КАК Пол
	|ИЗ
	|	ДанныеПола КАК ДанныеПола";
	
	Запрос.УстановитьПараметр("Фамилия",  ДанныеФИОДляПоиска.Фамилия);
	Запрос.УстановитьПараметр("Имя",      ДанныеФИОДляПоиска.Имя);
	Запрос.УстановитьПараметр("Отчество", ДанныеФИОДляПоиска.Отчество);

	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		Возврат Выборка.Пол;
	Иначе
		Возврат 3;
	КонецЕсли;
	
КонецФункции

// Выполняет поиск значений в классификатора по переданным частям ФИО.
//
// Параметры:
//  ЧастиФИО - Массив из Строка - данные для поиска в классификаторе.
//  ПолноеСовпадение - Булево - режим поиска. Если установлено Истина при поиске
//   будет проверяться равенство строки поиска с значением классификаторов,
//   если Ложь, для сравнения используется ПОДОБНО. Допускается указывать
//   параметры не точного поиска, например, Пет%.
//
//  Возвращаемое значение:
//    Структура - результат поиска:
//    * Фамилии - Массив из Структура - найденные фамилии:
//      ** Значение - Строка - найденное значение;
//      ** ПриоритетОтображения - Число - приоритет значения;
//      Свойство может не передаваться.
//    * Имена - Массив из Структура - найденные имена:
//      ** Значение - Строка - найденное значение;
//      ** ПриоритетОтображения - Число - приоритет значения;
//    * Отчества - Массив из Структура - найденные отчества:
//      ** Значение - Строка - найденное значение;
//
// Пример:
//	ЧастиФИО = Новый Массив;
//	ЧастиФИО.Добавить("Пет%");
//	Результат = ПодборФИО.НайтиФИО(ЧастиФИО, Ложь);
//
Функция НайтиФИО(ЧастиФИО, ПолноеСовпадение = Истина) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Фамилии", Новый Массив);
	Результат.Вставить("Имена", Новый Массив);
	Результат.Вставить("Отчества", Новый Массив);
	
	Если ЧастиФИО.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	ЧастиФИОЗапрос = Новый ТаблицаЗначений;
	ЧастиФИОЗапрос.Колонки.Добавить("Значение", ОбщегоНазначения.ОписаниеТипаСтрока(100));
	Для Каждого ЧастьФИО Из ЧастиФИО Цикл
		СтрокаТаблицы = ЧастиФИОЗапрос.Добавить();
		СтрокаТаблицы.Значение = ЧастьФИО;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЧастиФИОЗапрос.Значение КАК Значение
		|ПОМЕСТИТЬ ВТ_ЧастиФИО
		|ИЗ
		|	&ЧастиФИОЗапрос КАК ЧастиФИОЗапрос
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КлассификаторФИО.ВидДанных КАК ВидДанных,
		|	КлассификаторФИО.Значение КАК Значение,
		|	КлассификаторФИО.ПриоритетОтображения КАК ПриоритетОтображения
		|ИЗ
		|	РегистрСведений.КлассификаторФИО КАК КлассификаторФИО
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ЧастиФИО КАК ВТ_ЧастиФИО
		|		ПО КлассификаторФИО.Значение %Шаблон%";
	
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"%Шаблон%",
		?(ПолноеСовпадение,
			"= ВТ_ЧастиФИО.Значение",
			"ПОДОБНО ВТ_ЧастиФИО.Значение"));
	
	Запрос.УстановитьПараметр("ЧастиФИОЗапрос", ЧастиФИОЗапрос);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.ВидДанных = Перечисления.ВидДанныхФИО.Фамилия Тогда
			ДобавитьВРезультатПоиска(
					Результат.Фамилии,
					ВыборкаДетальныеЗаписи.Значение,
					ВыборкаДетальныеЗаписи.ПриоритетОтображения);
		ИначеЕсли ВыборкаДетальныеЗаписи.ВидДанных = Перечисления.ВидДанныхФИО.Имя Тогда
			ДобавитьВРезультатПоиска(
					Результат.Имена,
					ВыборкаДетальныеЗаписи.Значение,
					ВыборкаДетальныеЗаписи.ПриоритетОтображения);
		ИначеЕсли ВыборкаДетальныеЗаписи.ВидДанных = Перечисления.ВидДанныхФИО.Отчество Тогда
			ДобавитьВРезультатПоиска(
				Результат.Отчества,
				ВыборкаДетальныеЗаписи.Значение,
				ВыборкаДетальныеЗаписи.ПриоритетОтображения);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. РаботаСКлассификаторамиПереопределяемый.ПриДобавленииКлассификаторов.
//
Процедура ПриДобавленииКлассификаторов(Классификаторы) Экспорт
	
	Описатель = РаботаСКлассификаторами.ОписаниеКлассификатора();
	Описатель.Наименование           = НСтр("ru = 'Классификатор ФИО'");
	Описатель.Идентификатор          = ИдентификаторВСервисеКлассификаторов();
	Описатель.ОбновлятьАвтоматически = Истина;
	Описатель.ОбщиеДанные            = Истина;
	
	Классификаторы.Добавить(Описатель);
	
КонецПроцедуры

// См. РаботаСКлассификаторамиПереопределяемый.ПриЗагрузкеКлассификатора.
//
Процедура ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан) Экспорт
	
	Если Идентификатор <> ИдентификаторВСервисеКлассификаторов() Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла();
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	ДвоичныеДанные.Записать(ПутьКФайлу);
	
	Попытка
		
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.ОткрытьФайл(ПутьКФайлу);
		ДанныеКлассификатора = ПрочитатьJSON(ЧтениеJSON);
		ЧтениеJSON.Закрыть();
		УдалитьФайлы(ПутьКФайлу);
		
	Исключение
		
		УдалитьФайлы(ПутьКФайлу);
		ЗаписатьИнформациюВЖурналРегистрации(
			НСтр("ru = 'Некорректный формат файла классификатора, обработка прервана'"),
			Истина,
			Метаданные.РегистрыСведений.ПредельныеЗначенияОКВЭД2);
			
		Возврат;
		
	КонецПопытки;
	
	ФорматДанныхВерен = ПроверитьСтруктуруКлассификатора(ДанныеКлассификатора);
	
	Если ФорматДанныхВерен Тогда
		ОбработатьДанныеКлассификатора(ДанныеКлассификатора, Обработан);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает результат определения пола по данным классификатора.
//
// Параметры:
//  РежимПоиска - Строка - Режим поиска значения по классификатору, может принимать следующие значения:
//    "Фамилия", "Имя", "Отчество".
//  ВведенныеДанные - Структура - описывает данные ФИО, по которым будет выполняться поиск.
//    * Фамилия - Строка - описывает фамилию лица (ее часть когда РежимПоиска = "Фамилия").
//    * Имя - Строка - описывает имя лица (его часть когда РежимПоиска = "Имя").
//    * Отчество - Строка - описывает отчество лица (его часть когда РежимПоиска = "Отчество").
//
//  Возвращаемое значение:
//    Число - значение пола по данным классификатора, может принимать значения:
//      1- мужской, 2 - женский, 3 - допустимы оба.
//
Функция ОпределитьПолПоВведеннымДанным(РежимПоиска, ВведенныеДанные)
	
	Если (РежимПоиска = "Фамилия" Или ПустаяСтрока(ВведенныеДанные.Фамилия))
		И (РежимПоиска = "Имя" Или ПустаяСтрока(ВведенныеДанные.Имя))
		И (РежимПоиска = "Отчество" Или ПустаяСтрока(ВведенныеДанные.Отчество)) Тогда
		Возврат 3;
	КонецЕсли;
	
	ДанныеФИО = Новый Структура;
	ДанныеФИО.Вставить("Фамилия",  ?(РежимПоиска = "Фамилия", "", ВведенныеДанные.Фамилия));
	ДанныеФИО.Вставить("Имя",      ?(РежимПоиска = "Имя", "", ВведенныеДанные.Имя));
	ДанныеФИО.Вставить("Отчество", ?(РежимПоиска = "Отчество", "", ВведенныеДанные.Отчество));
	
	Возврат ОпределитьПол(ДанныеФИО);
	
КонецФункции

// Производит валидацию структуры данных классификатора.
//
// Параметры:
//  ДанныеКлассификатора - Структура - структура данных классификатора.
//
// Возвращаемое значение:
//  Булево - Истина если структура верна.
//
Функция ПроверитьСтруктуруКлассификатора(ДанныеКлассификатора)
	
	Если Не ЗначениеЗаполнено(ДанныеКлассификатора)
		Или ТипЗнч(ДанныеКлассификатора) <> Тип("Структура") Тогда
		
		ЗаписатьИнформациюВЖурналРегистрации(
			НСтр("ru = 'Отсутствуют данные или данные не являются структурой'"),
			Истина,
			Метаданные.РегистрыСведений.КлассификаторФИО);
			
		Возврат Ложь;
	
	// АПК:1415-выкл
	// Исключение- файлы классификаторов поставляются из внешних источников данных.
	
	ИначеЕсли Не ДанныеКлассификатора.Свойство("version")
		Или ТипЗнч(ДанныеКлассификатора.version) <> Тип("Число") Тогда
		
		ЗаписатьИнформациюВЖурналРегистрации(
			НСтр("ru = 'Отсутствует или неправильно заполнено свойство ""version""'"),
			Истина,
			Метаданные.РегистрыСведений.КлассификаторФИО);
			
		Возврат Ложь;
		
	ИначеЕсли Не ДанныеКлассификатора.Свойство("classifierData")
		Или ТипЗнч(ДанныеКлассификатора.classifierData) <> Тип("Структура") Тогда
		
		ЗаписатьИнформациюВЖурналРегистрации(
			НСтр("ru = 'Отсутствует или неправильно заполнено свойство ""classifierData""'"),
			Истина,
			Метаданные.РегистрыСведений.КлассификаторФИО);
			
		Возврат Ложь;
		
	ИначеЕсли Не ДанныеКлассификатора.classifierData.Свойство("names")
		Или ТипЗнч(ДанныеКлассификатора.classifierData.names) <> Тип("Массив") Тогда
		
		ЗаписатьИнформациюВЖурналРегистрации(
			НСтр("ru = 'Отсутствует или неправильно заполнено свойство ""names""'"),
			Истина,
			Метаданные.РегистрыСведений.КлассификаторФИО);
			
		Возврат Ложь;
		
	ИначеЕсли Не ДанныеКлассификатора.classifierData.Свойство("surnames")
		Или ТипЗнч(ДанныеКлассификатора.classifierData.surnames) <> Тип("Массив") Тогда
		
		ЗаписатьИнформациюВЖурналРегистрации(
			НСтр("ru = 'Отсутствует или неправильно заполнено свойство ""surnames""'"),
			Истина,
			Метаданные.РегистрыСведений.КлассификаторФИО);
			
		Возврат Ложь;
		
	ИначеЕсли Не ДанныеКлассификатора.classifierData.Свойство("secondNames")
		Или ТипЗнч(ДанныеКлассификатора.classifierData.secondNames) <> Тип("Массив") Тогда
		
		ЗаписатьИнформациюВЖурналРегистрации(
			НСтр("ru = 'Отсутствует или неправильно заполнено свойство ""secondNames""'"),
			Истина,
			Метаданные.РегистрыСведений.КлассификаторФИО);
			
		Возврат Ложь;
		
	// АПК:1415-вкл
	
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Производит разбор переданной структуры и записывает данные классификатора.
// В случае успешного завершения параметру "Обработан" присваивается значение равное Истина
//
// Параметры:
//  ДанныеКлассификатора - Структура - структура данных классификатора.
//  Обработан - Булево - признак успешной обработки данных классификатора.
//
Процедура ОбработатьДанныеКлассификатора(ДанныеКлассификатора, Обработан)
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("ВидДанных",            Новый ОписаниеТипов("ПеречислениеСсылка.ВидДанныхФИО"));
	ТаблицаДанных.Колонки.Добавить("Значение",             Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(200)));
	ТаблицаДанных.Колонки.Добавить("Пол",                  Новый ОписаниеТипов("Число"));
	ТаблицаДанных.Колонки.Добавить("ПриоритетОтображения", Новый ОписаниеТипов("Число"));
	
	ОбработатьВидДанныхКлассификатора(
		Перечисления.ВидДанныхФИО.Имя,
		ДанныеКлассификатора.classifierData.names,
		ТаблицаДанных);
	
	ОбработатьВидДанныхКлассификатора(
		Перечисления.ВидДанныхФИО.Отчество,
		ДанныеКлассификатора.classifierData.surnames,
		ТаблицаДанных);
	
	ОбработатьВидДанныхКлассификатора(
		Перечисления.ВидДанныхФИО.Фамилия,
		ДанныеКлассификатора.classifierData.secondNames,
		ТаблицаДанных);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = РегистрыСведений.КлассификаторФИО.СоздатьНаборЗаписей();
	Набор.Загрузить(ТаблицаДанных);
	Набор.Записать();
	
	Обработан = Истина;
	
КонецПроцедуры

// Производит заполнение таблицы по виду данными классификатора для его дальнейшей записи.
//
// Параметры:
//  ВидДанных - ПеречислениеСсылка.ВидДанныхФИО - обрабатываемый вид данных.
//  ДанныеКлассификатораПоВиду - Структура - данные классификатора по обрабатываемому виду.
//  ТаблицаДанных - ТаблицаЗначений - содержит подготовленные данные для записи в регистр.
//
Процедура ОбработатьВидДанныхКлассификатора(ВидДанных, ДанныеКлассификатораПоВиду, ТаблицаДанных)
	
	Для Каждого Элемент Из ДанныеКлассификатораПоВиду Цикл
		
		НовСтр = ТаблицаДанных.Добавить();
		НовСтр.ВидДанных            = ВидДанных;
		НовСтр.Значение             = Элемент["value"];
		НовСтр.Пол                  = Элемент["sex"];
		НовСтр.ПриоритетОтображения = Элемент["priority"];
		
	КонецЦикла;
	
КонецПроцедуры

// Добавляет запись в журнал регистрации.
//
// Параметры:
//  СообщениеОбОшибке - Строка - комментарий к записи журнала регистрации;
//  Ошибка - Булево - если истина будет установлен уровень журнала регистрации "Ошибка";
//  ОбъектМетаданных - ОбъектМетаданных - объект метаданных для которого регистрируется ошибка.
//
Процедура ЗаписатьИнформациюВЖурналРегистрации(
		СообщениеОбОшибке,
		Ошибка = Истина,
		ОбъектМетаданных = Неопределено) Экспорт
	
	УровеньЖР = ?(Ошибка, УровеньЖурналаРегистрации.Ошибка, УровеньЖурналаРегистрации.Информация);
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(),
		УровеньЖР,
		ОбъектМетаданных,
		,
		Лев(СообщениеОбОшибке, 5120));
	
КонецПроцедуры

// Возвращает имя события для журнала регистрации
//
// Возвращаемое значение:
//  Строка - имя события.
//
Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Подбор ФИО'",
		ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

// Формирует идентификатор классификатора данных подбора ФИО.
//
// Возвращаемое значение:
//  Строка - идентификатор классификатора.
//
Функция ИдентификаторВСервисеКлассификаторов()

	Возврат "FullNameData";

КонецФункции

// Формирует строку, начинающуюся с заглавной буквы.
//
// Параметры:
//  СтрокаДляПреобразования - Строка - стока для преобразования.
//
// Возвращаемое значение:
//  Строка - преобразованной строка.
//
Функция ЗаглавнаяБуква(СтрокаДляПреобразования)
	
	Возврат ВРег(Лев(СтрокаДляПреобразования, 1)) + Сред(НРег(СтрокаДляПреобразования), 2);
	
КонецФункции

// Производит подготовку данных поиска по переданному представлению.
//
// Параметры:
//  ДанныеФИОДляПоиска - Структура, Неопределено - описывает данные ФИО, по которым будет выполняться поиск.
//    * Фамилия - Строка - описывает фамилию лица (ее часть когда РежимПоиска = "Фамилия").
//    * Имя - Строка - описывает имя лица (его часть когда РежимПоиска = "Имя").
//    * Отчество - Строка - описывает отчество лица (его часть когда РежимПоиска = "Отчество").
//    * Представление - Строка - описывает ФИО лица (в тех случаях когда РежимПоиска = "ФИО").
//  ДанныеПредставления - Массив из Строка - представление ФИО разложенной на составляющие.
//  ВидДанных - Строка - Идентификатор вида данных для которых осуществляется поиск.
//
Процедура ПодготовитьДанныеПоискаПоПредставлению(
		ДанныеФИОДляПоиска,
		ДанныеПредставления = Неопределено,
		ВидДанных = Неопределено)
	
	ДанныеПредставления = СтрРазделить(ДанныеФИОДляПоиска.Представление, " ", Ложь);
	
	Для Индекс = 0 По ДанныеПредставления.ВГраница() Цикл
		ДанныеПредставления[Индекс] = ЗаглавнаяБуква(ДанныеПредставления[Индекс]);
	КонецЦикла;
	
	Если ДанныеПредставления.Количество() > 2 Тогда
		ДанныеФИОДляПоиска.Фамилия  = ДанныеПредставления[0];
		ДанныеФИОДляПоиска.Имя      = ДанныеПредставления[1];
		ДанныеФИОДляПоиска.Отчество = ДанныеПредставления[2];
		ВидДанных        = "Отчество";
	ИначеЕсли ДанныеПредставления.Количество() = 2 И Прав(ДанныеФИОДляПоиска.Представление, 1) = " " Тогда
		ДанныеФИОДляПоиска.Фамилия  = ДанныеПредставления[0];
		ДанныеФИОДляПоиска.Имя      = ДанныеПредставления[1];
		ДанныеПредставления.Добавить("");
		ВидДанных        = "Отчество";
	ИначеЕсли ДанныеПредставления.Количество() = 2 Тогда
		ДанныеФИОДляПоиска.Фамилия  = ДанныеПредставления[0];
		ДанныеФИОДляПоиска.Имя      = ДанныеПредставления[1];
		ВидДанных        = "Имя";
	ИначеЕсли ДанныеПредставления.Количество() = 1 И Прав(ДанныеФИОДляПоиска.Представление, 1) = " " Тогда
		ДанныеФИОДляПоиска.Фамилия  = ДанныеПредставления[0];
		ДанныеПредставления.Добавить("");
		ВидДанных        = "Имя";
	Иначе
		ВидДанных        = "Фамилия";
		ДанныеФИОДляПоиска.Фамилия  = ЗаглавнаяБуква(СокрЛП(ДанныеФИОДляПоиска.Представление));
	КонецЕсли;
	
КонецПроцедуры

// Формирует структуру для осуществления поиска по данным классификатора.
//
// Параметры:
//  ДанныеФИО - Структура, Неопределено - описывает данные ФИО, по которым будет выполняться поиск.
//    В случае если значение параметра "Пол" пустое, будет использована для его определения по данным классификатора:
//    * Фамилия - Строка, Неопределено - описывает фамилию лица (ее часть когда РежимПоиска = "Фамилия").
//      Свойство может не передаваться.
//    * Имя - Строка, Неопределено - описывает имя лица (его часть когда РежимПоиска = "Имя").
//      Свойство может не передаваться.
//    * Отчество - Строка, Неопределено - описывает отчество лица (его часть когда РежимПоиска = "Отчество").
//      Свойство может не передаваться.
//    * Представление - Строка - описывает ФИО лица (в тех случаях когда РежимПоиска = "ФИО").
//      Свойство может не передаваться.
//
// Возвращаемое значение:
//  Структура - данные для поиска по классификатору
//    * Фамилия - Строка, Неопределено - описывает фамилию лица (ее часть когда РежимПоиска = "Фамилия").
//    * Имя - Строка, Неопределено - описывает имя лица (его часть когда РежимПоиска = "Имя").
//    * Отчество - Строка, Неопределено - описывает отчество лица (его часть когда РежимПоиска = "Отчество").
//    * Представление - Строка - описывает ФИО лица (в тех случаях когда РежимПоиска = "ФИО").
//
Функция НовыйДанныеФИОДляПоиска(ДанныеФИО)
	
	ДанныеФИОДляПоиска  = Новый Структура;
	
	ДанныеФИОДляПоиска.Вставить("Фамилия",       "");
	ДанныеФИОДляПоиска.Вставить("Имя",           "");
	ДанныеФИОДляПоиска.Вставить("Отчество",      "");
	ДанныеФИОДляПоиска.Вставить("Представление", "");
	
	Для Каждого ЭлементФИО Из ДанныеФИО Цикл
		ДанныеФИОДляПоиска[ЭлементФИО.Ключ] = ЭлементФИО.Значение;
	КонецЦикла;
	
	Возврат ДанныеФИОДляПоиска;
	
КонецФункции

// Добавляет найденные значения в результат поиска.
//
// Параметры:
//  Результат - Массив из Структура - результат поиска;
//  Значение - Строка - найденное значение;
//  ПриоритетОтображения - Число - приоритет значения.
//
Процедура ДобавитьВРезультатПоиска(
		Результат,
		Значение,
		ПриоритетОтображения)
	
	Результат.Добавить(
		Новый Структура(
			"Значение, ПриоритетОтображения",
			Значение,
			ПриоритетОтображения));
	
КонецПроцедуры

#КонецОбласти
