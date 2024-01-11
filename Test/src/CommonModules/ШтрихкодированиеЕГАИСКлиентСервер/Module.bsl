#Область ПрограммныйИнтерфейс

// Дополняет свойства параметров сканирования необходимых для работы с алкогольной продукцией.
//
// Параметры:
//   ПараметрыСканирования - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//   ВидПродукции - ПеречислениеСсылка.ВидыПродукцииИС - добавляемый вид продукции,
//                - Неопределено - добавить все доступные для обработки виды продукции.
//
// Возвращаемое значение:
//   Булево - параметры сканирования успешно дополнены
//
Функция ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования, ВидПродукции = Неопределено) Экспорт
	
	Алкоголь = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная");
	
	Если ЗначениеЗаполнено(ВидПродукции) И ВидПродукции <> Алкоголь Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПараметрыСканирования.ДопустимыеВидыПродукции.Добавить(Алкоголь);
	ПараметрыСканирования.Вставить("ДокументЕГАИС",                                 Неопределено);
	ПараметрыСканирования.Вставить("КонтрольАкцизныхМарок",                         Ложь);
	ПараметрыСканирования.Вставить("ОрганизацияЕГАИС",                              Неопределено);
	ПараметрыСканирования.Вставить("АлкогольнаяПродукция",                          Неопределено);
	ПараметрыСканирования.Вставить("КонтрольПустогоСтатуса150СимвольныхМарок",      Истина);
	ПараметрыСканирования.Вставить("ИспользуетсяСоответствиеШтрихкодовСтрокДерева", Ложь);
	ПараметрыСканирования.Вставить("СоответствиеШтрихкодовСтрокДерева",             Неопределено);
	ПараметрыСканирования.Вставить("КонтрольЗаполненияМарокСНомеромИСерией",        Истина);
	ПараметрыСканирования.Вставить("ДоступныеСтатусы",                              Новый Массив);
	ПараметрыСканирования.Вставить("Номенклатура",                                  Неопределено);
	ПараметрыСканирования.Вставить("Характеристика",                                Неопределено);
	ПараметрыСканирования.Вставить("Серия",                                         Неопределено);
	ПараметрыСканирования.Вставить("КлючевыеРеквизиты",                             Новый Массив);
	ПараметрыСканирования.Вставить("Операция",                                      Неопределено);
	ПараметрыСканирования.Вставить("ЗапрашиватьНоменклатуру",                       Истина);
	ПараметрыСканирования.Вставить("ОбрабатыватьПивоВЕГАИС",                        Ложь);
	Возврат Истина;
	
КонецФункции

// Дополняет свойства параметров сканирования необходимых для работы с пивом средствами ЕГАИС.
//   Может использоваться для прикладных форм расширяющих функциональность ЕГАИС.
//   Подразумевается что поддержка алкогольной продукции включена.
//
// Параметры:
//   ПараметрыСканирования - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//
Процедура ВключитьПоддержкуПива(ПараметрыСканирования) Экспорт
	
	Если ПараметрыСканирования.ПодсистемаИСМПСуществует Тогда
		
		ПараметрыСканирования.ДопустимыеВидыПродукции.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Пиво"));
		ПараметрыСканирования.ОбрабатыватьПивоВЕГАИС = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Дополняет свойства параметров сканирования необходимых для работы с алкогольной продукцией.
//
// Параметры:
//   ПараметрыСканирования - (См. ШтрихкодированиеИСКлиент.ПараметрыСканирования).
//   Контекст - Произвольный - источник данных,
//   ФормаВыбора - Неопределено, ФормаКлиентскогоПриложения - альтернативный источник данных.
//
Процедура ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, Контекст, ФормаВыбора = Неопределено) Экспорт
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "ОрганизацияЕГАИС")
		И ЗначениеЗаполнено(Контекст.ОрганизацияЕГАИС) Тогда
		ПараметрыСканирования.ОрганизацияЕГАИС = Контекст.ОрганизацияЕГАИС;
	КонецЕсли;
	
	ИсточникПараметров = ?(ФормаВыбора = Неопределено, Контекст, ФормаВыбора);
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ИсточникПараметров, "Номенклатура") Тогда
		ПараметрыСканирования.Номенклатура = ИсточникПараметров.Номенклатура;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ИсточникПараметров, "Характеристика") Тогда
		ПараметрыСканирования.Характеристика = ИсточникПараметров.Характеристика;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьПараметрыСканирования(ПараметрыСканирования, Контекст, ВидПродукции, ФормаВыбора) Экспорт
	
	АлкогольнаяПродукция = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная");
	Пиво = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Пиво");
	
	Если ЗначениеЗаполнено(ВидПродукции)
			И ВидПродукции <> АлкогольнаяПродукция
			И ВидПродукции <> Пиво Тогда
		Возврат;
		
	ИначеЕсли Контекст = Неопределено И ВидПродукции = АлкогольнаяПродукция Тогда
		
		ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
		Возврат;
		
	КонецЕсли;
	
	// Заполнение параметров сканирования по данным контекста.
	Если ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Обработка.ПроверкаИПодборАлкогольнойПродукцииЕГАИС") Тогда
	
		ЗаполнитьПараметрыСканированияПроверкаИПодборАлкогольнойПродукцииЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора);
	
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.АктПостановкиНаБалансЕГАИС") Тогда
		
		ЗаполнитьПараметрыСканированияАктПостановкиНаБалансЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.АктСписанияЕГАИС") Тогда
		
		ЗаполнитьПараметрыСканированияАктСписанияЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ВозвратИзРегистра2ЕГАИС") Тогда
		
		ЗаполнитьПараметрыСканированияВозвратИзРегистра2ЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ЗапросАкцизныхМарокЕГАИС") Тогда
		
		ЗаполнитьПараметрыСканированияЗапросАкцизныхМарокЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ПередачаВРегистр2ЕГАИС") Тогда
		
		ЗаполнитьПараметрыСканированияПередачаВРегистр2ЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ТТНВходящаяЕГАИС") Тогда
		
		ЗаполнитьПараметрыСканированияТТНВходящаяЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ТТНИсходящаяЕГАИС") Тогда
		
		ЗаполнитьПараметрыСканированияТТНИсходящаяЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ЧекЕГАИСВозврат") Тогда
		
		ЗаполнитьПараметрыСканированияЧекЕГАИСВозврат(ПараметрыСканирования, Контекст, ФормаВыбора);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ЧекЕГАИС") Тогда
		
		ЗаполнитьПараметрыСканированияЧекЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Обработка.ПомощникКорректировкиОстатковЕГАИС") Тогда
		
		ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
		ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, Контекст, ФормаВыбора);
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Справочник.КлассификаторАлкогольнойПродукцииЕГАИС")
		Или ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Справочник.Справки2ЕГАИС") Тогда
		
		ЗаполнитьПараметрыСканированияЕГАИСБезЗапросаМарки(ПараметрыСканирования, Контекст, ФормаВыбора)
		
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Контекст, "Документ.ОтчетОПроизводствеЕГАИС") Тогда
		
		ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
		ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, Контекст, ФормаВыбора);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьСохраненныйВыборДанныхПоАлкогольнойПродукции(Форма, ДанныеШтрихкода) Экспорт

	Если ДанныеШтрихкода = Неопределено Или Не ДанныеШтрихкода.Свойство("ДополнительныеПараметры") Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = ДанныеШтрихкода.ДополнительныеПараметры;
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ЗапомнитьВыбор") 
		И ДополнительныеПараметры.ЗапомнитьВыбор Тогда
		
		Если ДополнительныеПараметры.Свойство("ДанныеВыбора")
			И ТипЗнч(ДополнительныеПараметры.ДанныеВыбора) = Тип("Структура") 
			И ДополнительныеПараметры.ДанныеВыбора.Количество() > 0 Тогда
			
			Форма.ДанныеВыбораПоМаркируемойПродукции  = ДополнительныеПараметры.ДанныеВыбора;
			Форма.ДанныеВыбораПоМаркируемойПродукции.Вставить("АлкогольнаяПродукция", ДанныеШтрихКода.АлкогольнаяПродукция);
			Форма.ДанныеВыбораПоМаркируемойПродукции.Вставить("ТипШтрихКода", ДанныеШтрихКода.ТипШтрихКода);
			Форма.СохраненВыборПоМаркируемойПродукции = Истина;
			
			ШтрихкодированиеИСКлиентСервер.ОтобразитьСохраненныйВыборПоМаркируемойПродукции(Форма);
			
		КонецЕсли;
		
	ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ДанныеВыбораПоМаркируемойПродукции")
		И Форма.ДанныеВыбораПоМаркируемойПродукции <> Неопределено Тогда
		
		ТребуетсяСбросВыбора = Ложь;
		
		Если Форма.ДанныеВыбораПоМаркируемойПродукции.ТипШтрихкода <> ДанныеШтрихкода.ТипШтрихкода
			И Форма.ДанныеВыбораПоМаркируемойПродукции <> Неопределено Тогда
			
			ТребуетсяСбросВыбора = Истина;
			
		ИначеЕсли ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.PDF417")
			И ЗначениеЗаполнено(ДанныеШтрихкода.АлкогольнаяПродукция)
			И ДанныеШтрихкода.АлкогольнаяПродукция <> Форма.ДанныеВыбораПоМаркируемойПродукции.АлкогольнаяПродукция Тогда
			
			ТребуетсяСбросВыбора = Истина;
			
		КонецЕсли;
		
		Если ТребуетсяСбросВыбора Тогда
			
			Форма.ДанныеВыбораПоМаркируемойПродукции  = Неопределено;
			Форма.СохраненВыборПоМаркируемойПродукции = Ложь;
			ШтрихкодированиеИСКлиентСервер.ОтобразитьСохраненныйВыборПоМаркируемойПродукции(Форма);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ДополнитьПараметрыЗаполненияТабличнойЧасти(ПараметрыЗаполнения) Экспорт
	
	ПараметрыЗаполнения.Вставить("ПроверитьСериюРассчитатьСтатус", Ложь);
	
КонецПроцедуры

// Проверяет код маркировки на соответствие шаблону логистической упаковки
// 
// Параметры:
// 	Штрихкод - Строка - проверяемый код маркировки
// Возвращаемое значение:
// 	Булево - Истина, если код соответствует логистической упаковке.
Функция ЭтоШтрихкодЛогистическойУпаковки(Штрихкод) Экспорт
	
	ОсновнойАлфавит    = "0123456789";
	РасширенныйАлфавит = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	
	Если СтрДлина(Штрихкод) = 18 Тогда 
		
		// Код маркировки для коробов и палет: Код ФСРАР(12) + Порядковый номер(6)
		Если Не ШтрихкодированиеИСКлиентСервер.КодСоответствуетАлфавиту(Штрихкод, ОсновнойАлфавит) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	ИначеЕсли СтрДлина(Штрихкод) = 26 Тогда //  + Тип логистической единицы(1) + Номер площадки(2) + Год(4) + Порядковый номер(9)
		
		// Код маркировки для коробов: Код ФСРАР(12)
		Если Не ШтрихкодированиеИСКлиентСервер.КодСоответствуетАлфавиту(Сред(Штрихкод, 1, 12), РасширенныйАлфавит) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		// Тип логистической единицы(1)
		Если Не ШтрихкодированиеИСКлиентСервер.КодСоответствуетАлфавиту(Сред(Штрихкод, 13, 1), ОсновнойАлфавит) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		// Номер площадки(2)
		Если Не ШтрихкодированиеИСКлиентСервер.КодСоответствуетАлфавиту(Сред(Штрихкод, 14, 2), РасширенныйАлфавит) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		// Год(4)
		Если Не ШтрихкодированиеИСКлиентСервер.КодСоответствуетАлфавиту(Сред(Штрихкод, 16, 4), ОсновнойАлфавит) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		// Серийный номер(9) - любые символы
		
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполнениеПараметровСканирования

Процедура ЗаполнитьПараметрыСканированияПроверкаИПодборАлкогольнойПродукцииЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
	//!
	ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, ИсточникДанных, ФормаВыбора);
	
	ПараметрыСканирования.РазрешенаОбработкаНеНайденныхЛогистическихУпаковок = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияАктПостановкиНаБалансЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
	ВключитьПоддержкуПива(ПараметрыСканирования);
	ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, ИсточникДанных, ФормаВыбора);
	
	
	Если ИсточникДанных.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр3") Тогда
		ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.КПостановкеНаБаланс"));
	КонецЕсли;
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.Отсутствует"));
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
	
	ПараметрыСканирования.КонтрольАкцизныхМарок         = Истина;
	ПараметрыСканирования.Операция                      = ИсточникДанных.ВидДокумента;
	ПараметрыСканирования.ДокументОснование             = ИсточникДанных.ДокументОснование;
	ПараметрыСканирования.ДокументЕГАИС                 = ИсточникДанных.Ссылка;
	ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок = "АктПостановкиНаБаланс";
	ПараметрыСканирования.ОрганизацияЕГАИС              = ИсточникДанных.ОрганизацияЕГАИС;
	ПараметрыСканирования.СоздаватьШтрихкодУпаковки     = ИсточникДанных.ВидДокумента <> ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр2");
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "ДанныеВыбораПоМаркируемойПродукции") Тогда
		ПараметрыСканирования.ДанныеВыбораПоМаркируемойПродукции = Контекст.ДанныеВыбораПоМаркируемойПродукции;
	КонецЕсли;
	
	ПараметрыСканирования.ИспользуютсяДанныеВыбораПоМаркируемойПродукции = Истина;
	ПараметрыСканирования.ВозможнаЗагрузкаТСД                            = Истина;
	ПараметрыСканирования.КонтрольПустогоСтатуса150СимвольныхМарок       = Ложь;
	Если ИсточникДанных.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр3") Тогда
		ПараметрыСканирования.ТолькоМаркируемаяПродукция = Истина;
	КонецЕсли;
	ПараметрыСканирования.РазрешенаОбработкаБезУказанияМарки = Истина;
	ПараметрыСканирования.ПоддерживаютсяОперацииАгрегации    = Истина;
	
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("КоличествоПоСправке1");
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НомерТТН");
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ДатаТТН");
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ДатаРозлива");
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НомерПодтвержденияЕГАИС");
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ДатаПодтвержденияЕГАИС");
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияВозвратИзРегистра2ЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
	ВключитьПоддержкуПива(ПараметрыСканирования);
	ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, ИсточникДанных, ФормаВыбора);
	
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "ДанныеВыбораПоМаркируемойПродукции") Тогда
		ПараметрыСканирования.ДанныеВыбораПоМаркируемойПродукции = Контекст.ДанныеВыбораПоМаркируемойПродукции;
	КонецЕсли;
	
	ПараметрыСканирования.ИспользуютсяДанныеВыбораПоМаркируемойПродукции = Истина;
	ПараметрыСканирования.ВозможнаЗагрузкаТСД                            = Истина;
	
	ПараметрыСканирования.КонтрольАкцизныхМарок               = Истина;
	ПараметрыСканирования.Операция                            = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ВозвратИзРегистра2");
	ПараметрыСканирования.ДокументОснование                   = ИсточникДанных.ДокументОснование;
	ПараметрыСканирования.ДокументЕГАИС                       = ИсточникДанных.Ссылка;
	ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок       = "Продажа";
	ПараметрыСканирования.ОрганизацияЕГАИС                    = ИсточникДанных.ОрганизацияЕГАИС;
	ПараметрыСканирования.СоздаватьШтрихкодУпаковки           = Ложь;
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок  = Неопределено;
	ПараметрыСканирования.РазрешенаОбработкаБезУказанияМарки  = Истина;
	ПараметрыСканирования.КонтрольУникальностиКодовМаркировки = Ложь;
	ПараметрыСканирования.ПоддерживаютсяОперацииАгрегации     = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияЗапросАкцизныхМарокЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
	ВключитьПоддержкуПива(ПараметрыСканирования);
	ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, ИсточникДанных, ФормаВыбора);
	
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.КПостановкеНаБаланс"));
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.Реализована"));
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.НеПодтверждена"));
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВРезерве"));
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.Отсутствует"));
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
	
	ПараметрыСканирования.КонтрольАкцизныхМарок              = Истина;
	ПараметрыСканирования.Операция                           = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЗапросАкцизныхМарок");
	ПараметрыСканирования.ДокументОснование                  = ИсточникДанных.ДокументОснование;
	ПараметрыСканирования.ДокументЕГАИС                      = ИсточникДанных.Ссылка;
	ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок      = "Продажа";
	ПараметрыСканирования.ОрганизацияЕГАИС                   = ИсточникДанных.ОрганизацияЕГАИС;
	ПараметрыСканирования.СоздаватьШтрихкодУпаковки          = Ложь;
	ПараметрыСканирования.ТолькоМаркируемаяПродукция         = Истина;
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок = Неопределено;
	ПараметрыСканирования.РазрешенаОбработкаБезУказанияМарки = Истина;
	
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ТипМарки");
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("СерияМарки");
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НомерМарки");
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("КодАкцизнойМарки");
	
	// Отключен контроль справок 2 и номенклатуры
	ПараметрыСканирования.КонтрольЗаполненияМарокСНомеромИСерией = Ложь;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияАктСписанияЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
	ВключитьПоддержкуПива(ПараметрыСканирования);
	ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, ИсточникДанных, ФормаВыбора);
	
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
	
	ПараметрыСканирования.КонтрольАкцизныхМарок         = Истина;
	ПараметрыСканирования.Операция                      = ИсточникДанных.ВидДокумента;
	ПараметрыСканирования.ДокументОснование             = ИсточникДанных.ДокументОснование;
	ПараметрыСканирования.ДокументЕГАИС                 = ИсточникДанных.Ссылка;
	ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок = "АктСписания";
	ПараметрыСканирования.ОрганизацияЕГАИС              = ИсточникДанных.ОрганизацияЕГАИС;
	ПараметрыСканирования.СоздаватьШтрихкодУпаковки     = 
		ИсточникДанных.ВидДокумента <> ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктСписанияИзРегистра2");
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "ДанныеВыбораПоМаркируемойПродукции") Тогда
		ПараметрыСканирования.ДанныеВыбораПоМаркируемойПродукции = Контекст.ДанныеВыбораПоМаркируемойПродукции;
	КонецЕсли;
	
	ПараметрыСканирования.ИспользуютсяДанныеВыбораПоМаркируемойПродукции = Истина;
	ПараметрыСканирования.ВозможнаЗагрузкаТСД                            = Истина;
	
	Если ИсточникДанных.ВидДокумента = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.АктСписанияИзРегистра3") Тогда
		ПараметрыСканирования.ТолькоМаркируемаяПродукция = Истина;
	КонецЕсли;
	
	ПараметрыСканирования.РазрешенаОбработкаБезУказанияМарки = Истина;
	ПараметрыСканирования.ПоддерживаютсяОперацииАгрегации    = Истина;
	
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Цена");
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияПередачаВРегистр2ЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
	ВключитьПоддержкуПива(ПараметрыСканирования);
	ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, ИсточникДанных, ФормаВыбора);
	
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "ДанныеВыбораПоМаркируемойПродукции") Тогда
		ПараметрыСканирования.ДанныеВыбораПоМаркируемойПродукции = Контекст.ДанныеВыбораПоМаркируемойПродукции;
	КонецЕсли;
	
	ПараметрыСканирования.ИспользуютсяДанныеВыбораПоМаркируемойПродукции = Истина;
	ПараметрыСканирования.ВозможнаЗагрузкаТСД                            = Истина;
	ПараметрыСканирования.РазрешенаОбработкаБезУказанияМарки             = Истина;
	
	ПараметрыСканирования.КонтрольАкцизныхМарок               = Ложь;
	ПараметрыСканирования.Операция                            = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ПередачаВРегистр2");
	ПараметрыСканирования.ДокументОснование                   = ИсточникДанных.ДокументОснование;
	ПараметрыСканирования.ДокументЕГАИС                       = ИсточникДанных.Ссылка;
	ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок       = "Продажа";
	ПараметрыСканирования.ОрганизацияЕГАИС                    = ИсточникДанных.ОрганизацияЕГАИС;
	ПараметрыСканирования.СоздаватьШтрихкодУпаковки           = Ложь;
	ПараметрыСканирования.ИмяТабличнойЧастиШтрихкодыУпаковок  = Неопределено;
	ПараметрыСканирования.КонтрольУникальностиКодовМаркировки = Ложь;
	ПараметрыСканирования.ПоддерживаютсяОперацииАгрегации     = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияТТНИсходящаяЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
	ВключитьПоддержкуПива(ПараметрыСканирования);
	ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, ИсточникДанных, ФормаВыбора);
	
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
	
	ПараметрыСканирования.КонтрольАкцизныхМарок     = Истина;
	ПараметрыСканирования.Операция                  = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ТТН");
	ПараметрыСканирования.ДокументОснование         = ИсточникДанных.ДокументОснование;
	ПараметрыСканирования.ДокументЕГАИС             = ИсточникДанных.Ссылка;
	ПараметрыСканирования.ОрганизацияЕГАИС          = ИсточникДанных.Грузоотправитель;
	ПараметрыСканирования.СоздаватьШтрихкодУпаковки = Истина;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "ДанныеВыбораПоМаркируемойПродукции") Тогда
		ПараметрыСканирования.ДанныеВыбораПоМаркируемойПродукции = Контекст.ДанныеВыбораПоМаркируемойПродукции;
	КонецЕсли;
	ПараметрыСканирования.ИспользуютсяДанныеВыбораПоМаркируемойПродукции = Истина;
	ПараметрыСканирования.ВозможнаЗагрузкаТСД                            = Истина;
	ПараметрыСканирования.РазрешенаОбработкаБезУказанияМарки             = Истина;
	ПараметрыСканирования.ПоддерживаютсяОперацииАгрегации                = Истина;
	
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Цена");
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("НомерПартии");
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("ИдентификаторУпаковки");
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияЧекЕГАИСВозврат(ПараметрыСканирования, Контекст, ФормаВыбора)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
	ВключитьПоддержкуПива(ПараметрыСканирования);
	ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, ИсточникДанных, ФормаВыбора);
	
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.Реализована"));
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
	
	ПараметрыСканирования.КонтрольАкцизныхМарок                          = Истина;
	ПараметрыСканирования.Операция                                       = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ");
	ПараметрыСканирования.ДокументОснование                              = ИсточникДанных.ДокументОснование;
	ПараметрыСканирования.ДокументЕГАИС                                  = ИсточникДанных.Ссылка;
	ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок                  = "Возврат";
	ПараметрыСканирования.ОрганизацияЕГАИС                               = ИсточникДанных.ОрганизацияЕГАИС;
	ПараметрыСканирования.СоздаватьШтрихкодУпаковки                      = Истина;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "ДанныеВыбораПоМаркируемойПродукции") Тогда
		ПараметрыСканирования.ДанныеВыбораПоМаркируемойПродукции             = Контекст.ДанныеВыбораПоМаркируемойПродукции;
	КонецЕсли;
	ПараметрыСканирования.ИспользуютсяДанныеВыбораПоМаркируемойПродукции = Истина;
	ПараметрыСканирования.ВозможнаЗагрузкаТСД                            = Истина;
	ПараметрыСканирования.ТолькоМаркируемаяПродукция                     = Истина;
	ПараметрыСканирования.РазрешенаОбработкаБезУказанияМарки             = Истина;
	ПараметрыСканирования.ПоддерживаютсяОперацииАгрегации                = Истина;
	
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Цена");
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияЧекЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
	ВключитьПоддержкуПива(ПараметрыСканирования);
	ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, ИсточникДанных, ФормаВыбора);
	
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ВНаличии"));
	ПараметрыСканирования.ДоступныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАкцизныхМарок.ПустаяСсылка"));
	
	ПараметрыСканирования.КонтрольАкцизныхМарок         = Истина;
	ПараметрыСканирования.Операция                      = ПредопределенноеЗначение("Перечисление.ВидыДокументовЕГАИС.ЧекККМ");
	ПараметрыСканирования.ДокументОснование             = ИсточникДанных.ДокументОснование;
	ПараметрыСканирования.ДокументЕГАИС                 = ИсточникДанных.Ссылка;
	ПараметрыСканирования.ОперацияКонтроляАкцизныхМарок = "Продажа";
	ПараметрыСканирования.ОрганизацияЕГАИС              = ИсточникДанных.ОрганизацияЕГАИС;
	ПараметрыСканирования.СоздаватьШтрихкодУпаковки     = Истина;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "ДанныеВыбораПоМаркируемойПродукции") Тогда
		ПараметрыСканирования.ДанныеВыбораПоМаркируемойПродукции = Контекст.ДанныеВыбораПоМаркируемойПродукции;
	КонецЕсли;
	
	ПараметрыСканирования.ИспользуютсяДанныеВыбораПоМаркируемойПродукции = Истина;
	ПараметрыСканирования.ВозможнаЗагрузкаТСД                            = Истина;
	ПараметрыСканирования.ТолькоМаркируемаяПродукция                     = Истина;
	ПараметрыСканирования.РазрешенаОбработкаБезУказанияМарки             = Истина;
	ПараметрыСканирования.ПоддерживаютсяОперацииАгрегации                = Истина;
	
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Цена");
	ПараметрыСканирования.КлючевыеРеквизиты.Добавить("Штрихкод");
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияТТНВходящаяЕГАИС(ПараметрыСканирования, Контекст, ФормаВыбора)
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Контекст, "Объект") Тогда
		ИсточникДанных = Контекст.Объект;
	Иначе
		ИсточникДанных = Контекст;
	КонецЕсли;
	
	ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
	ВключитьПоддержкуПива(ПараметрыСканирования);
	ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, ИсточникДанных, ФормаВыбора);
	ПараметрыСканирования.КонтрольПустогоСтатуса150СимвольныхМарок = Ложь;
	ПараметрыСканирования.ПоддерживаютсяОперацииАгрегации          = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыСканированияЕГАИСБезЗапросаМарки(ПараметрыСканирования, Контекст, ФормаВыбора)
	
	ВключитьПоддержкуАлкогольнойПродукции(ПараметрыСканирования);
	ЗаполнитьБазовыеПараметрыСканирования(ПараметрыСканирования, Контекст, ФормаВыбора);
	ПараметрыСканирования.РазрешеноЗапрашиватьКодМаркировки = Ложь;
	ПараметрыСканирования.ТолькоМаркируемаяПродукция        = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
