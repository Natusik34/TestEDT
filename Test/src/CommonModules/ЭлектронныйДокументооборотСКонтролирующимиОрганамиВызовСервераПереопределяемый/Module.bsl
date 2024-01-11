// Процедура вызывается при изменении статуса отправки (сдачи) документа.
//
// Параметры:
//	Ссылка - ссылка на документ.
//	СтатусОтправки - ПеречислениеСсылка.СтатусыОтправки - актуальный статус
//
Процедура ПриИзмененииСтатусаОтправкиДокумента(Ссылка, СтатусОтправки) Экспорт
	
	
КонецПроцедуры

// Функция должна возвращать дату начала и дату окончания периода
// документа (отчета) по заданной ссылке.
//
// Параметры:
//  Ссылка - ссылка на отчет (документ).
// 
// Результат:
//	Структура, если документ (отчет) представляется за период.
//	Ключи структуры: ДатаНачала, ДатаОкончания. Ключи содержат дату начала
//	и дату окончания периода, за который оформлен документ. Если документ
//	(отчет) представляется не за период, то в ключах ДатаНачала и ДатаОкончания
//	возвращается дата документа.
//
Функция ПолучитьДатыПериодаДокумента(Ссылка) Экспорт
	
	ПериодОтчета = Новый Структура("ДатаНачала, ДатаОкончания");
	
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.СправкиНДФЛДляПередачиВНалоговыйОрган") Тогда
		ГодОтчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "НалоговыйПериод");
		ПериодОтчета.ДатаНачала = Дата(ГодОтчета, 1, 1);
		ПериодОтчета.ДатаОкончания = Дата(ГодОтчета, 12, 31);
		Возврат ПериодОтчета;
	Иначе
		Возврат ПерсонифицированныйУчетУНФ.ПолучитьДатыПериодаДокумента(Ссылка);
	КонецЕсли;
	
КонецФункции

// Функция выгружает заданный документ и возвращает свойства файла выгрузки.
//
// Параметры:
//  Ссылка - ссылка на отчет (документ).
//
// Результат:
//	Структура или Неопределено, если не удалось сформировать файл выгрузки.
//	Ключи структуры:
//		- АдресФайлаВыгрузки - адрес двоичных данных файла выгрузки во временном хранилище
//		- ТипФайлаВыгрузки - строка
//		- ИмяФайлаВыгрузки - короткое имя файла выгрузки (с расширением)
//		- КодировкаФайлаВыгрузки - перечисление КодировкаТекста
Функция ВыгрузитьДокумент(Ссылка, УникальныйИдентификатор = Неопределено) Экспорт
	
	ФайлДляОтправки = Новый Структура("АдресФайлаВыгрузки, ИмяФайлаВыгрузки, Ошибки, ТипФайлаВыгрузки, КодировкаФайлаВыгрузки");
	
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.СправкиНДФЛДляПередачиВНалоговыйОрган") Тогда
		
		ФайлДляОтправки.ИмяФайлаВыгрузки =  ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ИмяФайла")+".XML";
		ФайлДляОтправки.АдресФайлаВыгрузки =  СправкиПоНДФЛ.СохранитьФайлВыгрузкиСправки2НДФЛ(Ссылка);
		ФайлДляОтправки.ТипФайлаВыгрузки = "СправкиНДФЛДляПередачиВНалоговыйОрган";
		ФайлДляОтправки.КодировкаФайлаВыгрузки =  КодировкаТекста.ANSI;
		Возврат ФайлДляОтправки;
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.УведомлениеОбОстаткахПрослеживаемыхТоваров") Тогда
		ИнформацияОФайле = ПрослеживаемостьБРУ.ВыгрузитьУведомлениеОбОстаткахПрослеживаемыхТоваров(Ссылка);
		Если ИнформацияОФайле = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		ФайлДляОтправки.ИмяФайлаВыгрузки = ИнформацияОФайле.ИмяФайлаВыгрузки;
		ФайлДляОтправки.АдресФайлаВыгрузки = ИнформацияОФайле.АдресФайлаВыгрузки;
		ФайлДляОтправки.Ошибки = ИнформацияОФайле.Ошибки;
		ФайлДляОтправки.ТипФайлаВыгрузки = "УведомлениеОбОстаткахПрослеживаемыхТоваров";
		ФайлДляОтправки.КодировкаФайлаВыгрузки =  КодировкаТекста.ANSI;
		Возврат ФайлДляОтправки;
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.УведомлениеОВвозеПрослеживаемыхТоваров") Тогда
		ИнформацияОФайле = ПрослеживаемостьБРУ.ВыгрузитьУведомлениеОВвозеПрослеживаемыхТоваров(Ссылка);
		Если ИнформацияОФайле = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		ФайлДляОтправки.ИмяФайлаВыгрузки = ИнформацияОФайле.ИмяФайлаВыгрузки;
		ФайлДляОтправки.АдресФайлаВыгрузки = ИнформацияОФайле.АдресФайлаВыгрузки;
		ФайлДляОтправки.Ошибки = ИнформацияОФайле.Ошибки;
		ФайлДляОтправки.ТипФайлаВыгрузки = "УведомлениеОВвозеПрослеживаемыхТоваров";
		ФайлДляОтправки.КодировкаФайлаВыгрузки =  КодировкаТекста.ANSI;
		Возврат ФайлДляОтправки;	
	ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.УведомлениеОПеремещенииПрослеживаемыхТоваров") Тогда
		ИнформацияОФайле = ПрослеживаемостьБРУ.ВыгрузитьУведомлениеОПеремещенииПрослеживаемыхТоваров(Ссылка);
		Если ИнформацияОФайле = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		ФайлДляОтправки.ИмяФайлаВыгрузки = ИнформацияОФайле.ИмяФайлаВыгрузки;
		ФайлДляОтправки.АдресФайлаВыгрузки = ИнформацияОФайле.АдресФайлаВыгрузки;
		ФайлДляОтправки.Ошибки = ИнформацияОФайле.Ошибки;
		ФайлДляОтправки.ТипФайлаВыгрузки = "УведомлениеОПеремещенииПрослеживаемыхТоваров";
		ФайлДляОтправки.КодировкаФайлаВыгрузки =  КодировкаТекста.ANSI;
		Возврат ФайлДляОтправки;
	Иначе 
		Возврат ПерсонифицированныйУчетУНФ.ВыгрузитьДокументы(Ссылка, УникальныйИдентификатор);		
	КонецЕсли;
	
КонецФункции

// Получает пакет электронных представлений документов.
//
// Параметры
//  МассивНДС - Массив - перечень документов для которых
//                 необходимо получить электронные представления в виде двоичных данных.
//  УникальныйИдентификаторФормы - УникальныйИдентификатор - уникальный идентификатор по которому
//                 осуществляется привязка двоичных данных во временном хранилище.
//
// Возвращаемое значение:
//   Соответствие - сответствие переданных ссылок на документы и массива структур с полями:
//                 ТипФайла - Строка - описание типа файла;
//                 ИмяФайла - Строка - имя файла с расширением;
//                 АдресВременногоХранилища - Строка - адрес временного хранилища, в котором размещены двоичные данные файла.
Функция ПолучитьФайлыВыгрузкиНДС(МассивНДС, УникальныйИдентификаторФормы) Экспорт
	
	Возврат Документы.ЖурналУчетаСчетовФактур.СформироватьЭлектронныеДокументы(МассивНДС, УникальныйИдентификаторФормы);			
	
КонецФункции

// Получает пакет электронных представлений документов.
//
// Параметры
//  МассивЭД - Массив - перечень документов для которых
//                 необходимо получить электронные представления в виде двоичных данных.
//  УникальныйИдентификаторФормы - УникальныйИдентификатор - уникальный идентификатор по которому
//                 осуществляется привязка двоичных данных во временном хранилище.
//
// Возвращаемое значение:
//   Соответствие - сответствие переданных ссылок на документы и массива структур с полями:
//                 ТипФайла - Строка - описание типа файла;
//                 ИмяФайла - Строка - имя файла с расширением;
//                 АдресВременногоХранилища - Строка - адрес временного хранилища, в котором размещены двоичные данные файла.
Функция ПолучитьФайлыВыгрузкиЭД(МассивЭД, УникальныйИдентификаторФормы) Экспорт
	
КонецФункции

// Функция возвращает свойства договоров для массива документов
//
//Параметры 
//	МассивСсылок -  массив ссылок на документы ИБ, на основании которых в данном прикладном решении 
//  формируется электронный документ вида «Акт приемки-сдачи работ (услуг)»
//
// Возвращаемое значение: 
//	Соответствие со следующими свойствами:
//	-	ключ соответствия - ссылка на выгружаемый документ ИБ, взятая из входящего параметра
//	-	значение соответствия - Структура, с полями:
//		-	НомерДоговора, тип: Строка 
//		-	ДатаДоговора, тип: Дата 
//  В случае, если требуемые реквизиты у договора не заполнены или при невозможности получения данных реквизитов,
//  следует помещать пустые значения указанных типов.
Функция ПолучитьНомерДатаДоговораДокументов(МассивСсылок) Экспорт
	
КонецФункции 

// Функция возвращает свойства сотрудника по СправочникСсылка.ФизическиеЛица и СправочникСсылка.Организации
//
// Параметры функции:
// 	СсылкаФизЛицо 		- СправочникСсылка.ФизическиеЛица
// 	ОрганизацияСсылка 	- СправочникСсылка.Организации
//
// Возвращаемое значение:
//   Структура со следующими полями:
//  ФИО - структура:
// 		* Фамилия	- Строка 	- фамилия сотрудника.
// 		* Имя		- Строка 	- имя сотрудника.
// 		* Отчество	- Строка 	- отчество сотрудника.
//  Серия			- Строка 	- серия документа, удостоверяющего личность сотрудника.
//  Номер			- Строка 	- номер документа, удостоверяющего личность сотрудника.
//  ДатаВыдачи		- Дата 		- дата выдачи документа, удостоверяющего личность сотрудника.
//  КемВыдан		- Строка 	- кем выдан документ, удостоверяющий личность сотрудника.
//  ВидДокумента	- СправочникСсылка.ВидыДокументовФизическихЛиц - вид документа, удостоверяющего личность сотрудника.
//  Должность		- Строка 	- должность сотрудника.
//  Подразделение	- Строка 	- подразделение, в котором работает сотрудник.
//  СНИЛС			- Строка 	- СНИЛС сотрудника.
// 
Функция ПолучитьДанныеИсполнителя(СсылкаФизЛицо, ОрганизацияСсылка) Экспорт
	
	Структура		= Новый Структура("ФИО,Серия,Номер,ДатаВыдачи,КемВыдан,ВидДокумента");
	Структура		= Новый Структура("ФИО,ДатаРождения,МестоРождения,Пол,КодПодразделения,Гражданство,Серия,Номер,ДатаВыдачи,КемВыдан,КодПодразделения,ВидДокумента,Подразделение,Должность");
	
	СтруктураФИО	= Новый Структура("Фамилия,Имя,Отчество");
	
	Если ТипЗнч(СсылкаФизЛицо) = Тип("СправочникСсылка.Сотрудники") Тогда
		ФизЛицо = СсылкаФизЛицо.ФизЛицо;
	ИначеЕсли ТипЗнч(СсылкаФизЛицо) = Тип("СправочникСсылка.Организации") Тогда
		ФизЛицо = СсылкаФизЛицо.ФизическоеЛицо;
	Иначе
		ФизЛицо = СсылкаФизЛицо;
	КонецЕсли;
		
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФИОФизическихЛицСрезПоследних.Фамилия,
	|	ФИОФизическихЛицСрезПоследних.Имя,
	|	ФИОФизическихЛицСрезПоследних.Отчество,
	|	ФИОФизическихЛицСрезПоследних.ФизическоеЛицо.СтраховойНомерПФР КАК СНИЛС,
	|	ФИОФизическихЛицСрезПоследних.ФизическоеЛицо.ДатаРождения КАК ДатаРождения,
	|	ФИОФизическихЛицСрезПоследних.ФизическоеЛицо.Гражданство КАК Гражданство,
	|	ФИОФизическихЛицСрезПоследних.ФизическоеЛицо.Пол КАК Пол
	|ИЗ
	|	РегистрСведений.ФИОФизическихЛиц.СрезПоследних КАК ФИОФизическихЛицСрезПоследних
	|ГДЕ
	|	ФИОФизическихЛицСрезПоследних.ФизическоеЛицо = &ФизическоеЛицо";
	
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизЛицо);
	
	Попытка
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			СтруктураФИО.Вставить("Фамилия",	Выборка.Фамилия);
			СтруктураФИО.Вставить("Имя",		Выборка.Имя);
			СтруктураФИО.Вставить("Отчество",	Выборка.Отчество);
			Структура.Вставить("ФИО",			СтруктураФИО);
			// получим СНИЛС сотрудника
			Если ТипЗнч(СсылкаФизЛицо) = Тип("СправочникСсылка.Организации") Тогда
				Структура.Вставить("СНИЛС", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаФизЛицо, "СтраховойНомерПФР"));
			Иначе
				Структура.Вставить("СНИЛС", Выборка.СНИЛС);
			КонецЕсли;
			Структура.Вставить("ДатаРождения", Выборка.ДатаРождения);
			Структура.Вставить("Пол", Выборка.Пол);
			Структура.Вставить("Гражданство", Выборка.Гражданство);
		КонецЦикла;
	Исключение
	КонецПопытки;

	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДокументыФизическихЛицСрезПоследних.Серия,
	|	ДокументыФизическихЛицСрезПоследних.Номер,
	|	ДокументыФизическихЛицСрезПоследних.ДатаВыдачи,
	|	ДокументыФизическихЛицСрезПоследних.КемВыдан,
	|	ДокументыФизическихЛицСрезПоследних.ВидДокумента,
	|	ДокументыФизическихЛицСрезПоследних.КодПодразделения
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц.СрезПоследних КАК ДокументыФизическихЛицСрезПоследних
	|ГДЕ
	|	ДокументыФизическихЛицСрезПоследних.Физлицо = &Физлицо
	|	И ДокументыФизическихЛицСрезПоследних.ЯвляетсяДокументомУдостоверяющимЛичность = ИСТИНА";
	
	Запрос.УстановитьПараметр("Физлицо", ФизЛицо);
	
	Попытка
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Структура.Вставить("Серия",			Выборка.Серия);
			Структура.Вставить("Номер",			Выборка.Номер);
			Структура.Вставить("ДатаВыдачи",	Выборка.ДатаВыдачи);
			Структура.Вставить("КемВыдан",		Выборка.КемВыдан);
			Структура.Вставить("ВидДокумента",	Выборка.ВидДокумента);
			Структура.Вставить("КодПодразделения",	Выборка.КодПодразделения);
		КонецЦикла;
	Исключение
	КонецПопытки;
	
	Должность = ПолучитьДолжностьСотрудникаПоФизЛицу(ФизЛицо, ОрганизацияСсылка);
	Если Должность <> Неопределено Тогда
		Структура.Вставить("Должность", Должность);
	КонецЕсли;  
	
	ДополнительныеПараметры = Новый Структура("ТолькоПервая", Истина);
	ТелефонРабочий = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
	СсылкаФизЛицо, Справочники.ВидыКонтактнойИнформации.ТелефонРабочийФизическиеЛица, , , ДополнительныеПараметры);
	Если ЗначениеЗаполнено(ТелефонРабочий) Тогда
		Структура.Вставить("ТелефонРабочий", ТелефонРабочий);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура("ТолькоПервая", Истина);
	ТелефонМобильный = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
	СсылкаФизЛицо, Справочники.ВидыКонтактнойИнформации.ТелефонМобильныйФизическиеЛица, , , ДополнительныеПараметры);
	Если ЗначениеЗаполнено(ТелефонМобильный) Тогда
		Структура.Вставить("ТелефонМобильный", ТелефонМобильный);
	КонецЕсли; 
	
	Возврат Структура;
	
КонецФункции

// Функция возвращает соответствие или массив данных об ответственных лицах организации
//	Параметры функции:
//		ОрганизацияСсылка - СправочникСсылка.Организации;
//		ПолучитьСоответствие - Булево.
//
//	Возвращаемое значение:
//			Соответствие или массив, сведений об ответственных лицах организации.
//		Если значение параметра "ПолучитьСоответствие" указано и значение параметра 
//		равно "Истина", то функция вернет коллекцию соответствие с ключем признака ответственного лица (тип "Строка")
//		и стуктуру данных физ. лица.
//			Структура данных физ. лца состоит из значения "должность" должности ответветственного лица (тип "Строка") 
//			и "СНИЛС" значение реквизита "СтраховойНомерПФР" справочника физ. лица (тип "Строка").
//		В противном случаи вернется массив ссылок с типом СправочникСсылка.ФизическиеЛица.
//
Функция ПолучитьДанныеОтветственныхЛиц(ОрганизацияСсылка, ПолучитьСоответствие = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Если ОрганизацияСсылка.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Организации.Ссылка КАК Руководитель,
		|	Организации.СтраховойНомерПФР КАК СНИЛС,
		|	"""" КАК Должность,
		|	""Руководитель"" КАК ОтветственноеЛицо
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Организации.ПодписьГлавногоБухгалтера.ФизическоеЛицо КАК Руководитель,
		|	Организации.ПодписьГлавногоБухгалтера.ФизическоеЛицо.СтраховойНомерПФР КАК СНИЛС,
		|	Организации.ПодписьГлавногоБухгалтера.Должность КАК Должность,
		|	""ГлавныйБухгалтер"" КАК ОтветственноеЛицо
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Ссылка";
		
	Иначе
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Организации.ПодписьРуководителя.ФизическоеЛицо КАК Руководитель,
		|	Организации.ПодписьРуководителя.ФизическоеЛицо.СтраховойНомерПФР КАК СНИЛС,
		|	Организации.ПодписьРуководителя.Должность КАК Должность,
		|	""Руководитель"" КАК ОтветственноеЛицо
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Организации.ПодписьГлавногоБухгалтера.ФизическоеЛицо,
		|	Организации.ПодписьГлавногоБухгалтера.ФизическоеЛицо.СтраховойНомерПФР,
		|	Организации.ПодписьГлавногоБухгалтера.Должность,
		|	""ГлавныйБухгалтер""
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Ссылка";
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Ссылка", ОрганизацияСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если ПолучитьСоответствие Тогда
		Данные = Новый Соответствие;
	Иначе
		Данные = Новый Массив;
	КонецЕсли; 
	
	Пока Выборка.Следующий() Цикл
		Если ПолучитьСоответствие Тогда
			СтруктураДанных = Новый Структура;
			СтруктураДанных.Вставить("Должность", Выборка.Должность);
			СтруктураДанных.Вставить("СНИЛС", Выборка.СНИЛС);
			Данные.Вставить(Выборка.ОтветственноеЛицо, СтруктураДанных);
		Иначе
			Данные.Добавить(Выборка.Руководитель);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Данные;
	
КонецФункции

// Функция должна возвращать код подчиненности реестра сведений на выплату пособий в ФСС по заданной ссылке
// Параметры:      
//  Ссылка - ссылка реестр сведений на выплату пособий в ФСС.
// 
// Результат:
//  Строка, 5 символов.  В случае неудачи - пустая строка.
Функция ПолучитьКодПодчиненностиРеестраСведенийНаВыплатуПособийФСС(Ссылка) Экспорт
	
КонецФункции

// Функция должна возвращать код ИФНС получателя отправляемого объекта
// Параметры:      
//  ОбъектСсылка - ссылка на отправляемый объект.
//   Результат:
//   Строка, длина 4. В случае неудачи - пустая строка
Функция ПолучитьКодИФНСПолучателяПоСсылке(ОбъектСсылка) Экспорт
	
КонецФункции

// Возвращает ссылку на Главного бухгалтера 
//
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, главного бухгалтера которой необходимо получить
//
// Возвращаемое значение:
//   СправочникСсылка.ФизическиеЛица - главный бухгалтер организации
//   Неопределено, если главный бухгалтер отсутствует
//
Функция ГлБухгалтер(Организация)  Экспорт
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЮридическоеФизическоеЛицо") = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		Возврат Неопределено;
	Иначе
		Возврат Организация.ПодписьГлавногоБухгалтера.ФизическоеЛицо;
	КонецЕсли;
	
КонецФункции

// Возвращает ссылку на Руководителя организации
//
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, руководителя которой необходимо получить
//
// Возвращаемое значение:
//   СправочникСсылка.ФизическиеЛица - руководитель организации
//   Неопределено, если руководитель отсутствует
//
Функция Руководитель(Организация) Экспорт
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЮридическоеФизическоеЛицо") = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		Возврат Организация.ФизическоеЛицо;
	Иначе
		Возврат Организация.ПодписьРуководителя.ФизическоеЛицо;
	КонецЕсли;
	
КонецФункции

// Функция для объекта-источника возвращает ссылку на организацию. 
// В данной функции необходимо определить получение организации для всех типов объектов, которые должны отоборажаться
// в журнале Управление обменом и не имеют реквизита с именем "Организация"
// 
// Параметры:
//  Источник - ДокументСсылка, СправочникСсылка  - объект, который отборажается в форме Управление обменом.
//
// Результат:
//  СправочникСсылка.Организации,
//	Неопределено, если получить ссылку на организацию не получилось
//
Функция ПолучитьСсылкуНаОрганизациюИсточника(Источник) Экспорт
		
КонецФункции

// Возвращает ИНН контрагента для случая, когда ИНН в справочнике Контрагенты не хранится в реквизите с именем ИНН 
//
// Параметры
//  Контрагент  - <Справочник.Контрагент> - Контрагент, для котрого необходимо получить ИНН
// Возвращаемое значение:
//   ИНН   - строка - ИНН контрагента
//
Функция ИННКонтрагента(Контрагент) Экспорт

КонецФункции

// Функция предназначена для поиска физического лица, найденного по переданным фамилии, имени и отчеству
//
// Параметры
//  Фамилия		- Строка - Фамилия физического лица
//  Имя			- Строка - Имя физического лица
//  Отчество	- Строка - Отчество физического лица
//  СНИЛС		- Строка - СНИЛС физического лица
//  Организация - СправочникиСсылка.Организации - организация, в которой работает физическое лицо
//
// Возвращаемое значение:
//   СправочникиСсылка.ФизическиеЛица - Физическое лицо, найденное по переданным фамилии, имени и отчеству
//		Если найдено несколько физических лиц, брать первого
//
Функция ФизЛицоПоФИО(Фамилия, Имя, Отчество, СНИЛС, Организация) Экспорт
	
	Возврат КадровыйУчет.ФизическоеЛицоПоФИОСНИЛСИОрганизации(Фамилия, Имя, Отчество, СНИЛС, Организация); 
	
КонецФункции

// Функция возвращает вид отправляемого документа 
// Параметры:      
//  ОбъектСсылка - ссылка на отправляемый объект.
//   Результат:
//	СправочникСсылка.ВидыОтправляемыхДокументов, в случае неудачи - пустая ссылка данного типа
//
Функция ПолучитьВидОтправляемогоДокументаПоСсылке(ОбъектСсылка) Экспорт
	
	Если ТипЗнч(ОбъектСсылка) = Тип("ДокументСсылка.УведомлениеОСпецрежимахНалогообложения") Тогда
		ВидУведомления = ОбъектСсылка.ВидУведомления;
		
		Если ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Форма_1_6_Учет Тогда 
			Возврат Справочники.ВидыОтправляемыхДокументов.ВыборНалоговогоОрганаДляПостановкиНаУчет;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_1 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.ОткрытиеЗакрытиеСчета;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_2 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.УчастиеВРоссийскихИностранныхОрганизациях;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_1 Тогда 
			Возврат Справочники.ВидыОтправляемыхДокументов.СозданиеОбособленныхПодразделений;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_2 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.ЗакрытиеОбособленныхПодразделений;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_4 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.РеорганизацияЛиквидацияОрганизации;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД1 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.ПостановкаНаУчетОрганизацииПлательщикаЕНВД;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД2 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.ПостановкаНаУчетПредпринимателяПлательщикаЕНВД;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД3 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.СнятиеСУчетаОрганизацииПлательщикаЕНВД;
		ИначеЕсли ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД4 Тогда
			Возврат Справочники.ВидыОтправляемыхДокументов.СнятиеСУчетаПредпринимателяПлательщикаЕНВД;
		Иначе
			Возврат Справочники.ВидыОтправляемыхДокументов.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция РеквизитыНеХранящиесяВБазе(Организация = Неопределено) Экспорт
	
	НаборРеквизитов = Новый Массив;
	НаборРеквизитов.Добавить(ПредопределенноеЗначение("Перечисление.ПараметрыПодключенияК1СОтчетности.НомерОсновнойПоставки1С"));
	НаборРеквизитов.Добавить(ПредопределенноеЗначение("Перечисление.ПараметрыПодключенияК1СОтчетности.ТелефонДополнительный"));
	НаборРеквизитов.Добавить(ПредопределенноеЗначение("Перечисление.ПараметрыПодключенияК1СОтчетности.ВладелецЭЦППодразделение"));
	НаборРеквизитов.Добавить(ПредопределенноеЗначение("Перечисление.ПараметрыПодключенияК1СОтчетности.ДополнительныйКодФСС"));
	
	Возврат НаборРеквизитов;
КонецФункции

// Процедура может возвращать настройки обмена с ЕГАИС УТМ. При пустой реализации будет использоваться стандартная
// реализация БРО, читающая регистр сведений "НастройкиОбменаЕГАИС", если он есть в метаданных конфигурации.
//
// Параметры:
//  Организация 				- СправочникСсылка.Организации - оранизация, для которой возвращаются настройки обмена ЕГАИС,
//								  может не учитываться с возвратом настроек обмена ЕГАИС по всем организациям
//  ТаблицаНастроекОбменаЕГАИС 	- ТаблицаЗначений - в случае возврата СтандартнаяОбработка равным Ложь в этот параметр
//								  нужно таблицу значений с настройкамиобмена ЕГАИС, содержащую колонки:
//								    АдресУТМ 			- Строка,
//								    ПортУТМ 			- Число,
//								    Таймаут 			- Число,
//								    ОбменНаСервере 		- Булево,
//								    ИдентификаторФСРАР 	- Строка,
//								  возврат Неопределено означает отсутствие поддержки настроек обмена ЕГАИС УТМ.
//  СтандартнаяОбработка 		- Булево - установить в Ложь в случае реализации возврата настроек обмена ЕГАИС,
//								  а при значении Истина будет использоваться стандартная реализация БРО.
//
Процедура ПриПолученииНастроекОбменаЕГАИС(Организация, ТаблицаНастроекОбменаЕГАИС, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#Область ДокументыПоТребованиюФНС

// Помещает присоединенные файлы объектов ИБ, 
// являющихся источниками для заполнения реквизитов сканированных документов, 
// представляемых по требованию ФНС, во временное хранилище и возвращает их свойства.
//
// Не требуется заполнять, если указанные присоединенные файлы хранятся при участии механизма БСП "Присоединенные файлы"
//
// Следует возвращать свойства всех файлов следующих типов: JPEG, TIFF, PNG, PDF.
//
// Параметры 
//	ИдентификаторФормыВладельца	- УникальныйИдентификатор, уникальный идентификатор формы, 
//		во временное хранилище которой требуется поместить данные присоединенных файлов.
//	ФайлыИсточников				- Соответствие, соответствие переданных ссылок на источники и массива структур 
//		Ключ 		- ссылка на источник
//		Значение 	- Массив, массив структур (начальное значение: пустой массив)
//		(каждый элемент массива -  структура свойств одного файла)
//
//		Поля структуры:
//			Имя			- Строка, короткое имя файла с расширением
//			Размер		- Число, размер файла в байтах
//			АдресДанных	- Строка, адрес временного хранилища
//
Процедура ПолучитьИзображенияПрисоединенныхФайловИсточников(ФайлыИсточников, ИдентификаторФормыВладельца) Экспорт
	
КонецПроцедуры


#КонецОбласти

Функция ПолучитьДолжностьСотрудникаПоФизЛицу(ФизическоеЛицо, Организация)
	
	Должность = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Подписи.Должность.Наименование КАК Должность
	|ИЗ
	|	Справочник.Подписи КАК Подписи
	|ГДЕ
	|	НЕ Подписи.ПометкаУдаления
	|	И Подписи.ФизическоеЛицо = &ФизическоеЛицо
	|	И Подписи.Организация = &Организация";
	
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Попытка
		Результат = Запрос.Выполнить();
	Исключение
		Возврат Должность;
	КонецПопытки;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Должность = Выборка.Должность;
	КонецЦикла;
	
	Возврат Должность;
	
КонецФункции
