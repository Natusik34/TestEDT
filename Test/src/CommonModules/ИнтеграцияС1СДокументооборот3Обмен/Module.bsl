////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Документооборотом"
// Модуль ИнтеграцияС1СДокументооборот3Обмен, сервер, внешнее соединение
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Помещает изменения в базу и возвращает ответ на запрос DMILPutChangesRequest.
//
// Параметры:
//   Сообщение - ОбъектXDTO - объект XDTO типа DMILPutChangesRequest:
//     * messageData - ДвоичныеДанные
//
// Возвращаемое значение:
//   ОбъектXDTO - объект XDTO типа DMILPutChangesResponse или DMILError.
//
Функция ЗаписатьИзмененияОбъектов(Сообщение) Экспорт
	
	Попытка
		
		ЧтениеСхемыXML = Новый ЧтениеXML;
		ЧтениеСхемыXML.УстановитьСтроку(Сообщение.DMXMLSchema);
		
		ПостроительDOM = Новый ПостроительDOM;
		ДокументDOM = ПостроительDOM.Прочитать(ЧтениеСхемыXML);
		ЧтениеСхемыXML.Закрыть();
		
		ПостроительСхемXML = Новый ПостроительСхемXML;
		СхемаXML = ПостроительСхемXML.СоздатьСхемуXML(ДокументDOM);
		
		НаборСхемXML = Новый НаборСхемXML;
		НаборСхемXML.Добавить(СхемаXML);
		
		ФабрикаDM = Новый ФабрикаXDTO(НаборСхемXML);
		
		ПараметрыСеанса.ИнтеграцияС1СДокументооборотВерсияСервиса = Сообщение.versionNumber;
		
		ИмяФайлаСообщенияОбмена = ПолучитьИмяВременногоФайла("xml");
		Сообщение.messageData.Записать(ИмяФайлаСообщенияОбмена);
		
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(ИмяФайлаСообщенияОбмена);
		ЧтениеXML.Прочитать();
		ЧтениеXML.Прочитать();
		
		МассивОшибок = Новый Массив;
		УзелДокументооборота = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.УзелДокументооборота();
		СоставПланаОбмена = Метаданные.ПланыОбмена.ИнтеграцияС1СДокументооборотомПереопределяемый.Состав;
		URIПространстваИменВебСервисаДокументооборота =
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.URIПространстваИменВебСервисаДокументооборота();
		
		Пока ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Цикл
			// Выполняется последовательное чтение одного объекта за другим
			ТипXDTO = ФабрикаDM.Тип(URIПространстваИменВебСервисаДокументооборота, ЧтениеXML.Имя);
			ОбъектXDTO = ФабрикаDM.ПрочитатьXML(ЧтениеXML, ТипXDTO);
			
			Попытка
				
				Если ОбъектXDTO.Тип() = ФабрикаDM.Тип(URIПространстваИменВебСервисаДокументооборота, "DMApprovalStateRecord") Тогда
					ЗаголовокОшибки = СтрШаблон(
						НСтр("ru = 'Ошибка при загрузке из 1С:Документооборот статуса ""%1"":
							|   * Идентификатор объекта ДО: %2.
							|   * Тип объекта ДО: %3.'",
							ОбщегоНазначения.КодОсновногоЯзыка()),
						ОбъектXDTO.status,
						ОбъектXDTO.id,
						ОбъектXDTO.type);
					
					ЗагрузитьСостояниеДокумента(ОбъектXDTO);
				Иначе
					Ссылки = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СсылкиПоВнешнимОбъектам(ОбъектXDTO);
					Для Каждого ОбъектСсылка Из Ссылки Цикл
						ЗаголовокОшибки = СтрШаблон(
							НСтр("ru = 'Ошибка при загрузке данных из объекта 1С:Документооборот ""%1"":
								|   * Навигационная ссылка на объект 1С:Документооборот: %2.
								|   * Навигационная ссылка на объект %3: %4.'",
								ОбщегоНазначения.КодОсновногоЯзыка()),
							ОбъектXDTO.name,
							ОбъектXDTO.objectID.navigationRef,
							ИнтеграцияС1СДокументооборотБазоваяФункциональность.СокращенноеНаименованиеКонфигурации(),
							ПолучитьНавигационнуюСсылку(ОбъектСсылка));
						
						ЗагрузитьСсылочныйОбъект(ОбъектСсылка, ОбъектXDTO, УзелДокументооборота, СоставПланаОбмена);
					КонецЦикла;
				КонецЕсли;
				
			Исключение
				ТекстОшибки = СтрШаблон(
					"%1
					|%2",
					ЗаголовокОшибки,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
				МассивОшибок.Добавить(ТекстОшибки);
				ЗаписьЖурналаРегистрации(
					ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИмяСобытияЖурналаРегистрации(
						НСтр("ru = 'Получение данных'", ОбщегоНазначения.КодОсновногоЯзыка())),
					УровеньЖурналаРегистрации.Ошибка,,,
					ТекстОшибки);
			КонецПопытки;
		КонецЦикла;
		
		ЧтениеXML = Неопределено;
		УдалитьФайлы(ИмяФайлаСообщенияОбмена);
		
		Если МассивОшибок.Количество() = 0 Тогда
			Возврат ИнтеграцияС1СДокументооборот3.СоздатьОбъектБИД("DMILPutChangesResponse");
		Иначе
			Возврат ИнтеграцияС1СДокументооборот3.ОписаниеОшибкиXDTO(
				НСтр("ru = 'Ошибка при загрузке сообщения обмена из 1С:Документооборот'"),
				СтрСоединить(
					МассивОшибок,
					"
					|-----
					|
					|"));
		КонецЕсли;
		
	Исключение
		
		Возврат ИнтеграцияС1СДокументооборот3.ОписаниеОшибкиXDTO(
			НСтр("ru = 'Ошибка при загрузке сообщения обмена из 1С:Документооборот'"),
			ИнтеграцияС1СДокументооборот3.ПолучитьОписаниеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
КонецФункции

// Возвращает измененные объекты, интегрированные с 1С:Документооборотом, и готовые к выгрузке.
//
// Параметры:
//   Прокси - WSПрокси - объект для подключения к web-сервисам Документооборота.
//   УзелОбмена - ПланОбменаСсылка.ИнтеграцияС1СДокументооборотомПереопределяемый - узел, по которому нужно
//     получить изменения.
//   ОбъектыКУдалениюИзРегистрацииИзменений - Массив из ЛюбаяСсылка - неявно возвращаемое значение,
//     содержит ссылки на объекты, не требующие выгрузки, и на успешно отправленные объекты.
//
// Возвращаемое значение:
//   Массив из Структура:
//     * Объект - ЛюбаяСсылка
//     * ТипОбъектаДО - Строка
//     * ИдентификаторОбъектаДО - Строка
//     * СписокВыражений - СписокXDTO
//     * ПечатныеФормы - СписокXDTO
//     * ТипыФайловПечатныхФорм - СписокXDTO
//     * ПравилоЗагрузкиВДО - ОбъектXDTO
//
Функция ЗарегистрированныеДанные(Прокси, УзелОбмена, ОбъектыКУдалениюИзРегистрацииИзменений) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МассивДанных = Новый Массив;
	СписокОбъектовИС = Новый Массив;
	СвязанныеОбъектыДО = Новый Соответствие;
	
	Для Каждого ЭлементСоставаПланаОбмена Из УзелОбмена.Метаданные().Состав Цикл
		ЗапросИзменения = Новый Запрос;
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	ТаблицаИзменения.Ссылка КАК Объект,
			|	ЕСТЬNULL(ОбъектыИнтегрированныеС1СДокументооборотом.ИдентификаторОбъектаДО, """") КАК ИдентификаторОбъектаДО,
			|	ЕСТЬNULL(ОбъектыИнтегрированныеС1СДокументооборотом.ТипОбъектаДО, """") КАК ТипОбъектаДО
			|ИЗ
			|	&ТаблицаИзменения КАК ТаблицаИзменения
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыИнтегрированныеС1СДокументооборотом КАК ОбъектыИнтегрированныеС1СДокументооборотом
			|		ПО ТаблицаИзменения.Ссылка = ОбъектыИнтегрированныеС1СДокументооборотом.Объект
			|ГДЕ
			|	ТаблицаИзменения.Узел = &УзелОбмена";
		ЗапросИзменения.Текст = СтрЗаменить(
			ТекстЗапроса,
			"&ТаблицаИзменения",
			СтрШаблон("%1.%2",
				ЭлементСоставаПланаОбмена.Метаданные.ПолноеИмя(),
				"Изменения"));
		ЗапросИзменения.УстановитьПараметр("УзелОбмена", УзелОбмена);
		
		ВыборкаОбъекты = ЗапросИзменения.Выполнить().Выбрать();
		
		Пока ВыборкаОбъекты.Следующий() Цикл
			Если ЗначениеЗаполнено(ВыборкаОбъекты.ИдентификаторОбъектаДО)
					И ОбъектДОПоддерживаетОбмен(ВыборкаОбъекты.ТипОбъектаДО) Тогда
				СвязанныйОбъект = Новый Структура("ТипОбъектаДО, ИдентификаторОбъектаДО",
					ВыборкаОбъекты.ТипОбъектаДО,
					ВыборкаОбъекты.ИдентификаторОбъектаДО);
				СписокОбъектовИС.Добавить(ВыборкаОбъекты.Объект);
				СвязанныеОбъектыДО.Вставить(ВыборкаОбъекты.Объект, СвязанныйОбъект);
			Иначе
				// Выгружать объект не требуется.
				ОбъектыКУдалениюИзРегистрацииИзменений.Добавить(ВыборкаОбъекты.Объект);
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
	ТребуютсяПечатныеФормы = ИнтеграцияС1СДокументооборот3.ДоступенФункционалФайлов();
	
	ПодходящиеПравилаИнтеграции = ИнтеграцияС1СДокументооборот3ВызовСервера.ПодходящиеПравилаИнтеграции(
		СписокОбъектовИС,
		Истина);
	СоответствиеПравилЗагрузкиВДООбъектамИС = ИнтеграцияС1СДокументооборот3.СоответствиеПравилЗагрузкиВДООбъектамИС(
		Прокси,
		СписокОбъектовИС,
		ПодходящиеПравилаИнтеграции);
	ПредварительныеДанные = ИнтеграцияС1СДокументооборот3.ПредварительныеДанныеДляВыгрузкиВДО(
		Прокси,
		СписокОбъектовИС,
		СоответствиеПравилЗагрузкиВДООбъектамИС,,
		ТребуютсяПечатныеФормы);
	СоответствиеСпискаВыраженийОбъектамИС = ПредварительныеДанные.СоответствиеСпискаВыраженийОбъектамИС;
	Если ТребуютсяПечатныеФормы Тогда
		СоответствиеПечатныхФормОбъектамИС = ПредварительныеДанные.СоответствиеПечатныхФормОбъектамИС;
		ТипыФайловПечатныхФорм = ПредварительныеДанные.ТипыФайловПечатныхФорм;
	КонецЕсли;
	
	// Добавим в выгрузку те объекты ИС, для которых есть подходящее правило загрузки в ДО.
	Для Каждого ОбъектИС Из СписокОбъектовИС Цикл
		
		ПравилоЗагрузкиВДО = СоответствиеПравилЗагрузкиВДООбъектамИС[ОбъектИС];
		Если ПравилоЗагрузкиВДО = Неопределено Тогда
			Если ПодходящиеПравилаИнтеграции[ОбъектИС].Количество() = 0 Тогда
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'Объект ""%1"" (%2) зарегистрирован к обмену данными со связанным объектом в 1С:Документооборот,
						|но подходящие правила интеграции не найдены.'"),
					ОбъектИС,
					ТипЗнч(ОбъектИС));
			Иначе
				ТекстОшибки = СтрШаблон(
					НСтр("ru = 'Объект ""%1"" (%2) зарегистрирован к обмену данными со связанным объектом в 1С:Документооборот,
						|но не найдено подходящее правило загрузки данных в 1С:Документооборот.'"),
					ОбъектИС,
					ТипЗнч(ОбъектИС));
			КонецЕсли;
			
			ЗаписьЖурналаРегистрации(
				ИнтеграцияС1СДокументооборотБазоваяФункциональность.ИмяСобытияЖурналаРегистрации(
					НСтр("ru = 'Отправка данных'", ОбщегоНазначения.КодОсновногоЯзыка())),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.ПланыОбмена.ИнтеграцияС1СДокументооборотомПереопределяемый,
				ОбъектИС,
				ТекстОшибки);
			Продолжить;
		КонецЕсли;
		
		ИнтегрированныйОбъект = Новый Структура("Объект", ОбъектИС);
		ИнтегрированныйОбъект.Вставить("ТипОбъектаДО", СвязанныеОбъектыДО[ОбъектИС].ТипОбъектаДО);
		ИнтегрированныйОбъект.Вставить("ИдентификаторОбъектаДО", СвязанныеОбъектыДО[ОбъектИС].ИдентификаторОбъектаДО);
		ИнтегрированныйОбъект.Вставить("СписокВыражений", СоответствиеСпискаВыраженийОбъектамИС[ОбъектИС]);
		ИнтегрированныйОбъект.Вставить("ПравилоЗагрузкиВДО", ПравилоЗагрузкиВДО);
		ИнтегрированныйОбъект.Вставить("ТребуютсяПечатныеФормы", ТребуютсяПечатныеФормы);
		Если ТребуютсяПечатныеФормы Тогда
			ИнтегрированныйОбъект.Вставить("ПечатныеФормы", СоответствиеПечатныхФормОбъектамИС[ОбъектИС]);
			ИнтегрированныйОбъект.Вставить("ТипыФайловПечатныхФорм", ТипыФайловПечатныхФорм[ОбъектИС]);
		КонецЕсли;
		
		МассивДанных.Добавить(ИнтегрированныйОбъект);
		ОбъектыКУдалениюИзРегистрацииИзменений.Добавить(ОбъектИС);
		
	КонецЦикла;
	
	Возврат МассивДанных;
	
КонецФункции

// Возвращает объект XDTO, содержащий обновляемые изменения объекта.
//
// Параметры:
//   Прокси - WSПрокси - объект для подключения к web-сервисам Документооборота.
//   ДанныеОбъекта - См. ИнтеграцияС1СДокументооборот3Обмен.ЗарегистрированныеДанные
//   КонтрольОтправкиФайлов - см. ИнтеграцияС1СДокументооборотБазоваяФункциональность.КонтрольОтправкиФайлов
//
// Возвращаемое значение:
//   ОбъектXDTO
//
Функция ПолучитьXDTOИзмененийИзОбъекта(Прокси, ДанныеОбъекта, КонтрольОтправкиФайлов) Экспорт
	
	СтруктураСозданияОбъекта = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(
		Прокси,
		"DMIncomingDataRequestStructure",
		ДанныеОбъекта.Объект);
	
	СтруктураСозданияОбъекта.incomingData = ИнтеграцияС1СДокументооборот3.ВходящиеДанныеОбъектаИС(
		Прокси,
		ДанныеОбъекта.Объект,
		ДанныеОбъекта.СписокВыражений);
	
	СтруктураСозданияОбъекта.updatingObject = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьObjectID(
		Прокси,
		ДанныеОбъекта.ИдентификаторОбъектаДО,
		ДанныеОбъекта.ТипОбъектаДО);
	
	СтруктураСозданияОбъекта.dataLoadingRule = ДанныеОбъекта.ПравилоЗагрузкиВДО;
	
	Если ДанныеОбъекта.ТребуютсяПечатныеФормы Тогда
		СписокФайлов = СтруктураСозданияОбъекта.files; // СписокXDTO
		ПечатныеФормыКСозданию = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПечатныеФормыКСозданию(
			ДанныеОбъекта.Объект,
			ИнтеграцияС1СДокументооборот3.ПрисоединяемыеПечатныеФормы(ДанныеОбъекта.ПечатныеФормы),
			Перечисления.ТипыФайловСохраненияПечатныхФормОбъектов[ДанныеОбъекта.ТипыФайловПечатныхФорм],
			КонтрольОтправкиФайлов,
			Истина);
		Для Каждого ПараметрыСоздания Из ПечатныеФормыКСозданию Цикл
			ФайлXDTO = ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ФайлXDTOИзПараметровСоздания(
				Прокси,
				ПараметрыСоздания);
			СписокФайлов.Добавить(ФайлXDTO);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СтруктураСозданияОбъекта;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗагрузитьСостояниеДокумента(ОбъектXDTO)
	
	ЗапросСвязанныйОбъект = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Объект
		|ИЗ
		|	РегистрСведений.ОбъектыИнтегрированныеС1СДокументооборотом
		|ГДЕ
		|	ТипОбъектаДО = &ТипОбъектаДО
		|	И ИдентификаторОбъектаДО = &ИдентификаторОбъектаДО");
	ЗапросСвязанныйОбъект.УстановитьПараметр("ТипОбъектаДО", ОбъектXDTO.type);
	ЗапросСвязанныйОбъект.УстановитьПараметр("ИдентификаторОбъектаДО", ОбъектXDTO.ID);
	
	Выборка = ЗапросСвязанныйОбъект.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Если ОбъектXDTO.status = Неопределено Тогда // запись удалена (например, прерывание)
			Действие = НСтр("ru = 'Удаление статуса'", ОбщегоНазначения.КодОсновногоЯзыка());
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ПриИзмененииСостоянияСогласования(
				ОбъектXDTO.ID,
				ОбъектXDTO.type,
				Неопределено,
				Ложь,
				Выборка.Объект);
		Иначе
			Действие = НСтр("ru = 'Установка статуса'", ОбщегоНазначения.КодОсновногоЯзыка());
			Состояние = Перечисления.СостоянияСогласованияВДокументообороте.ЗначениеСоответствующееСтатусуДО(
				ОбъектXDTO.status);
			ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.ПриИзмененииСостоянияСогласования(
				ОбъектXDTO.ID,
				ОбъектXDTO.type,
				Состояние,
				Ложь,
				Выборка.Объект,
				ОбъектXDTO.name,
				ОбъектXDTO.date);
		КонецЕсли;
	Исключение
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Действие: %1.
									|%2'", ОбщегоНазначения.КодОсновногоЯзыка()),
			Действие,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗагрузитьСсылочныйОбъект(ОбъектСсылка, ОбъектXDTO, УзелДокументооборота, СоставПланаОбмена)
	
	ПодходящиеПравила = ИнтеграцияС1СДокументооборот3ВызовСервера.ПодходящиеПравилаИнтеграцииОбъекта(
		ОбъектСсылка,
		Истина);
	Если ПодходящиеПравила = Неопределено Или ПодходящиеПравила.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не найдены подходящие правила интеграции'", ОбщегоНазначения.КодОсновногоЯзыка());
	КонецЕсли;
	Правило = ПодходящиеПравила[0];
	
	Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.СвойствоУстановлено(ОбъектXDTO, "files") Тогда
		
		Если ОбъектXDTO.files.Количество() > 0 Тогда
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриПоявленииПрисоединенныхФайловДокументооборота(
				ОбъектXDTO.objectID.ID,
				ОбъектXDTO.objectID.type,
				ОбъектСсылка,
				Истина);
		Иначе
			ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриУдаленииПрисоединенныхФайловДокументооборота(
				ОбъектXDTO.objectID.ID,
				ОбъектXDTO.objectID.type,
				ОбъектСсылка);
		КонецЕсли;
		
	КонецЕсли;
	
	Объект = ОбъектСсылка.ПолучитьОбъект();
	
	ИсходнаяПометкаУдаления = Объект.ПометкаУдаления;
	Обновление = Истина;
	ТребуетсяПерепроведение = Ложь;
	
	ЕстьИзменения = Справочники.ПравилаИнтеграцииС1СДокументооборотом3.ЗаполнитьОбъектИСПоОбъектуXDTO(
		Объект,
		ОбъектXDTO,
		Правило,
		Обновление,
		ТребуетсяПерепроведение);
	
	Если Не ЕстьИзменения Тогда
		Возврат;
	КонецЕсли;
	
	ОшибкаПроверкиЗаполнения = "";
	
	Попытка
		
		Действие = НСтр("ru = 'Сохранение изменений'", ОбщегоНазначения.КодОсновногоЯзыка());
		
		Если Объект.ПометкаУдаления И Не ИсходнаяПометкаУдаления Тогда
			
			Объект.Заблокировать();
			
			МетаданныеОбъекта = Объект.Метаданные();
			Если Метаданные.Документы.Содержит(МетаданныеОбъекта)
					И МетаданныеОбъекта.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить
					И Объект.Проведен Тогда
				
				Действие = НСтр("ru = 'Удаление с отменой проведения'",
					ОбщегоНазначения.КодОсновногоЯзыка());
				
				Отказ = Ложь;
				РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения;
				ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПередЗаписьюОбъектаИС(
					Объект,
					Отказ,
					РежимЗаписи);
				Если Не Отказ Тогда
					Объект.Записать(РежимЗаписи);
				КонецЕсли;
				
			Иначе
				
				Действие = НСтр("ru = 'Удаление'", ОбщегоНазначения.КодОсновногоЯзыка());
				Объект.ОбменДанными.Загрузка = Истина;
				
				Отказ = Ложь;
				ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПередЗаписьюОбъектаИС(
					Объект,
					Отказ);
				Если Не Отказ Тогда
					Объект.Записать();
				КонецЕсли;
				
			КонецЕсли;
			
			Объект.Разблокировать();
			
		Иначе
			
			Если Объект.ПроверитьЗаполнение() Тогда
				
				Объект.Заблокировать();
				
				Если ТребуетсяПерепроведение Тогда
					
					Действие = НСтр("ru = 'Проведение'", ОбщегоНазначения.КодОсновногоЯзыка());
					
					Отказ = Ложь;
					РежимЗаписи = РежимЗаписиДокумента.Проведение;
					РежимПроведения = РежимПроведенияДокумента.Неоперативный;
					ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПередЗаписьюОбъектаИС(
						Объект,
						Отказ,
						РежимЗаписи,
						РежимПроведения);
					Если Не Отказ Тогда
						Объект.Записать(РежимЗаписи, РежимПроведения);
					КонецЕсли;
					
				Иначе
					
					Действие = НСтр("ru = 'Запись'", ОбщегоНазначения.КодОсновногоЯзыка());
					Объект.ОбменДанными.Загрузка = Истина;
					
					Отказ = Ложь;
					ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.ПередЗаписьюОбъектаИС(
						Объект,
						Отказ);
					Если Не Отказ Тогда
						Объект.Записать();
					КонецЕсли;
					
				КонецЕсли;
				
				Объект.Разблокировать();
				
			Иначе
				
				СообщенияПользователю = ПолучитьСообщенияПользователю(Истина);
				ТекстСообщения = Новый Массив;
				ТекстСообщения.Добавить(
					НСтр("ru = 'Ошибка заполнения:'", ОбщегоНазначения.КодОсновногоЯзыка()));
				Для Каждого СообщениеПользователю Из СообщенияПользователю Цикл
					ТекстСообщения.Добавить(СообщениеПользователю.Текст);
				КонецЦикла;
				ОшибкаПроверкиЗаполнения = СтрСоединить(ТекстСообщения, Символы.ПС);
				
			КонецЕсли;
			
		КонецЕсли;
		
	Исключение
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Действие: %1.
									|%2'", ОбщегоНазначения.КодОсновногоЯзыка()),
			Действие,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Если ОшибкаПроверкиЗаполнения <> "" Тогда
		ВызватьИсключение ОшибкаПроверкиЗаполнения;
	КонецЕсли;
	
	Если ИнтеграцияС1СДокументооборот3.ДоступенФункционалФайлов() Тогда
		РегистрыСведений.ОбъектыКОбновлениюПечатныхФорм.Добавить(ОбъектСсылка, Правило);
	КонецЕсли;
	
	Если СоставПланаОбмена.Содержит(Объект.Метаданные()) Тогда
		ПланыОбмена.УдалитьРегистрациюИзменений(УзелДокументооборота, Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Функция ОбъектДОПоддерживаетОбмен(ТипОбъектаДО)
	
	ОбъектыСПоддержкойОбмена = Новый Массив;
	ОбъектыСПоддержкойОбмена.Добавить("DMMeeting");
	ОбъектыСПоддержкойОбмена.Добавить("DMCorrespondent");
	
	Возврат ИнтеграцияС1СДокументооборот3.ЭтоДокументДО3(ТипОбъектаДО)
		Или ОбъектыСПоддержкойОбмена.Найти(ТипОбъектаДО) <> Неопределено;
	
КонецФункции

#КонецОбласти