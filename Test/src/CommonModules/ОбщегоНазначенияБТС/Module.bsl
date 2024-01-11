#Область ПрограммныйИнтерфейс

// Проверяет, является ли переданный объект метаданных объектом ОбъектМетаданныхКонфигурация.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является конфигурацией.
//
Функция ЭтоОбъектМетаданныхКонфигурация(Знач ОбъектМетаданных) Экспорт
	
	Возврат ТипЗнч(ОбъектМетаданных) = Тип("ОбъектМетаданныхКонфигурация");
	
КонецФункции

// Проверяет, является ли переданный объект метаданных подсистемой.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является подсистемой.
//
Функция ЭтоПодсистема(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеПодсистемы.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных параметром сеанса.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является параметром сеанса.
//
Функция ЭтоПараметрСеанса(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеПараметрыСеанса.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных общим реквизитом.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является общим реквизитом.
//
Функция ЭтоОбщийРеквизит(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеОбщиеРеквизиты.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных константной.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является константой.
//
Функция ЭтоКонстанта(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеКонстанты.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных справочником.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является справочником.
//
Функция ЭтоСправочник(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеСправочники.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных документом.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является документом.
//
Функция ЭтоДокумент(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеДокументы.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных перечислением.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является перечислением.
//
Функция ЭтоПеречисление(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеПеречисления.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных бизнес-процессом.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является бизнес-процессом.
//
Функция ЭтоБизнесПроцесс(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеБизнесПроцессы.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных задачей.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является задачей.
//
Функция ЭтоЗадача(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеЗадачи.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных планом счетов.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является планом счетов.
//
Функция ЭтоПланСчетов(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеПланыСчетов.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных планом обмена.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является планом обмена.
//
Функция ЭтоПланОбмена(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеПланыОбмена.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных планом видов расчета.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является планом видов расчета.
//
Функция ЭтоПланВидовРасчета(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеПланыВидовРасчета.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных планом видов расчета.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является планом видов характеристик.
//
Функция ЭтоПланВидовХарактеристик(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеПланыВидовХарактеристик.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных ссылочным.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является ссылочным.
//
Функция ЭтоСсылочныеДанные(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеСсылочныеДанные.Получить(ОбъектМетаданных) = Истина;
		
КонецФункции

// Проверяет, является ли переданный объект метаданных ссылочным с поддержкой предопределенных элементов.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект поддерживает предопределенные элементы.
//
Функция ЭтоСсылочныеДанныеПоддерживающиеПредопределенныеЭлементы(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеСсылочныеДанныеПоддерживающиеПредопределенныеЭлементы.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных регистром сведений.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является регистром сведений.
//
Функция ЭтоРегистрСведений(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеРегистрыСведений.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных регистром накопления.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является регистром накопления.
//
Функция ЭтоРегистрНакопления(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеРегистрыНакопления.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных регистром бухгалтерии.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является регистром бухгалтерии.
//
Функция ЭтоРегистрБухгалтерии(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеРегистрыБухгалтерии.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных регистром расчета.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является регистром расчета.
//
Функция ЭтоРегистрРасчета(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеРегистрыРасчета.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных перерасчетом.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является перерасчетом.
//
Функция ЭтоНаборЗаписейПерерасчета(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеНаборыЗаписейПерерасчета.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных последовательности.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является последовательностью.
//
Функция ЭтоНаборЗаписейПоследовательности(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеНаборыЗаписейПоследовательности.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных набором записей.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является набором записей.
//
Функция ЭтоНаборЗаписей(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеНаборыЗаписей.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных независимым набором записей.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является независимым набором записей.
//
Функция ЭтоНезависимыйНаборЗаписей(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеНезависимыеНаборыЗаписей.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных набором записей, поддерживающим итоги.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект поддерживает итоги.
//
Функция ЭтоНаборЗаписейПоддерживающийИтоги(Знач ОбъектМетаданных) Экспорт
	
	Если ЭтоРегистрСведений(ОбъектМетаданных) Тогда
		
		Если ТипЗнч(ОбъектМетаданных) = Тип("Строка") Тогда
			ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ОбъектМетаданных);
		КонецЕсли;
		
		Возврат (ОбъектМетаданных.РазрешитьИтогиСрезПервых ИЛИ ОбъектМетаданных.РазрешитьИтогиСрезПоследних);
		
	ИначеЕсли ЭтоРегистрНакопления(ОбъектМетаданных) Тогда
		
		Возврат Истина;
		
	ИначеЕсли ЭтоРегистрБухгалтерии(ОбъектМетаданных) Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных журналом документов.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является журналом документов.
//
Функция ЭтоЖурналДокументов(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеЖурналыДокументов.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных регламентным заданием.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является регламентным заданием.
//
Функция ЭтоРегламентноеЗадание(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеРегламентныеЗадания.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Проверяет, является ли переданный объект метаданных внешним источником данных.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является внешним источникоам данным.
//
Функция ЭтоВнешнийИсточникДанных(Знач ОбъектМетаданных) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.МодельКонфигурации().ВсеВнешниеИсточникиДанных.Получить(ОбъектМетаданных) = Истина;
	
КонецФункции

// Возвращает: примитивный ли это тип или нет.
//
// Параметры:
//  ПроверяемыйТип - Тип - проверяемый тип.
//
// Возвращаемое значение:
//   Булево - Истина, если тип примитивный.
//
Функция ЭтоПримитивныйТип(Знач ПроверяемыйТип) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.ОписаниеПримитивныхТипов().СодержитТип(ПроверяемыйТип);
	
КонецФункции

// Возвращает: ссылочный ли это тип или нет.
//
// Параметры:
//  ПроверяемыйТип - Тип - проверяемый тип.
//
// Возвращаемое значение:
//   Булево - Истина, если тип примитивный.
//
Функция ЭтоСсылочныйТип(Знач ПроверяемыйТип) Экспорт
	
	Возврат ОбщегоНазначенияБТСПовтИсп.ОписаниеСсылочныхТипов().СодержитТип(ПроверяемыйТип);
	
КонецФункции

// Проверяет, что тип содержит набор ссылочных типов.
//
// Параметры:
//  ОписаниеТипов - ОписаниеТипов - набор ссылочных типов.
//
// Возвращаемое значение:
//   Булево - Истина, если тип содержит набор ссылочных типов.
//
Функция ЭтоНаборТиповСсылок(Знач ОписаниеТипов) Экспорт
	
	Если ОписаниеТипов.Типы().Количество() < 2 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СериализацияОписанияТипов = СериализаторXDTO.ЗаписатьXDTO(ОписаниеТипов);
	
	Если СериализацияОписанияТипов.TypeSet.Количество() > 0 Тогда
		
		СодержитНаборыСсылок = Ложь;
		
		Для Каждого НаборТипов Из СериализацияОписанияТипов.TypeSet Цикл
			
			Если НаборТипов.URIПространстваИмен = "http://v8.1c.ru/8.1/data/enterprise/current-config" Тогда
				
				Если НаборТипов.ЛокальноеИмя = "AnyRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "CatalogRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "DocumentRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "BusinessProcessRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "TaskRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "ChartOfAccountsRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "ExchangePlanRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "ChartOfCharacteristicTypesRef"
						ИЛИ НаборТипов.ЛокальноеИмя = "ChartOfCalculationTypesRef" Тогда
					
					СодержитНаборыСсылок = Истина;
					Прервать;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Возврат СодержитНаборыСсылок;
		
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает объект метаданных по типу ссылки
//
// Параметры:
//  ТипСсылки - Тип - тип ссылки.
//
// Возвращаемое значение: 
//	ОбъектМетаданных - объект метаданных
//
Функция ОбъектМетаданныхПоТипуСсылки(Знач ТипСсылки) Экспорт
	
	БизнесПроцесс = ОбщегоНазначенияБТСПовтИсп.СсылкиТочекМаршрутаБизнесПроцессов().Получить(ТипСсылки);
	Если БизнесПроцесс = Неопределено Тогда
		Ссылка = Новый(ТипСсылки);
		МетаданныеСсылки = Ссылка.Метаданные();
	Иначе
		МетаданныеСсылки = Метаданные.БизнесПроцессы[БизнесПроцесс];
	КонецЕсли;
	
	Возврат МетаданныеСсылки;
	
КонецФункции

// Проверяет включение объекта метаданных в состав разделителя в режиме, включающем разделение данных.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных,
//  ИмяРазделителя - Строка - имя общего реквизита - разделителя.
//
// Возвращаемое значение:
//   Булево - Истина, если объект является разделенным.
//
Функция ЭтоРазделенныйОбъектМетаданных(Знач ОбъектМетаданных, Знач ИмяРазделителя) Экспорт
	
	Свойства = СвойстваОбъектаМоделиКонфигурации(ОбщегоНазначенияБТСПовтИсп.ОписаниеМоделиДанныхКонфигурации(), ОбъектМетаданных);
	Возврат Свойства.РазделениеДанных.Свойство(ИмяРазделителя);
	
КонецФункции

// Возвращает перечень объектов, ссылки на которые содержатся в исходном объекте метаданных.
// Наборы ссылок и хранение ссылок в хранилище значения не учитываются.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - исходный объект метаданных,
//
// Возвращаемое значение: 
//	Массив из Строка - массив полных имен объектов метаданных.
//
Функция ЗависимостиОбъектаМетаданных(Знач ОбъектМетаданных) Экспорт
	
	Свойства = СвойстваОбъектаМоделиКонфигурации(ОбщегоНазначенияБТСПовтИсп.ОписаниеМоделиДанныхКонфигурации(), ОбъектМетаданных);
	Возврат Свойства.Зависимости;
	
КонецФункции

// Проверяет доступность объектов метаданных по текущим значениям функциональных опций.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - проверяемый объект метаданных.
//
// Возвращаемое значение:
//   Булево - Истина, если объект доступен по текущим функциональным опциям.
//
Функция ОбъектМетаданныхДоступенПоФункциональнымОпциям(Знач ОбъектМетаданных) Экспорт
	
	Свойства = СвойстваОбъектаМоделиКонфигурации(ОбщегоНазначенияБТСПовтИсп.ОписаниеМоделиДанныхКонфигурации(), ОбъектМетаданных);
	
	Если Свойства.ФункциональныеОпции.Количество() = 0 Тогда
		Возврат Истина;
	Иначе
		Результат = Ложь;
		Для Каждого ФункциональнаяОпция Из Свойства.ФункциональныеОпции Цикл
			Если ПолучитьФункциональнуюОпцию(ФункциональнаяОпция) Тогда
				Результат = Истина;
			КонецЕсли;
		КонецЦикла;
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

// Возвращает представление объекта метаданных.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - объект метаданных.
//
// Возвращаемое значение: 
//	Строка - представление объекта метаданных.
//
Функция ПредставлениеОбъектаМетаданных(Знач ОбъектМетаданных) Экспорт
	
	Свойства = СвойстваОбъектаМоделиКонфигурации(ОбщегоНазначенияБТСПовтИсп.ОписаниеМоделиДанныхКонфигурации(), ОбъектМетаданных);
	Возврат Свойства.Представление;
	
КонецФункции

// Возвращает перечень (с классификацией) прав, допустимых для объекта метаданных.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - объект метаданных.
//
// Возвращаемое значение: 
//	ТаблицаЗначений - таблица допустимых прав:
//	 * Имя - Строка - имя вида права, которое может использоваться для функции ПравоДоступа(),
//	 * Интерактивное - Булево - флаг того, что право ограничивает возможность выполнения интерактивных операций,
//	 * Чтение - Булево - флаг того, что право предоставляет или подразумевает
//		возможность чтения данных заданного объекта метаданных.
//	 * Изменение - Булево - флаг того, что право предоставляет или подразумевает
//		возможность изменения данных заданного объекта метаданных.
//	 * АдминистрированиеИнформационнойБазы - Булево - флаг того, что право
//		предоставляет или предполагает возможность администрирования (глобального для информационной базы).
//	 * АдминистрированиеОбластиДанных - Булево - флаг того, что право предоставляет
//		или предполагает возможность администрирования (глобального для
//		текущей области данных).
//
Функция ДопустимыеПраваДляОбъектаМетаданных(Знач ОбъектМетаданных) Экспорт
	
	ВидыПрав = Новый ТаблицаЗначений();
	ВидыПрав.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
	ВидыПрав.Колонки.Добавить("Интерактивное", Новый ОписаниеТипов("Булево"));
	ВидыПрав.Колонки.Добавить("Чтение", Новый ОписаниеТипов("Булево"));
	ВидыПрав.Колонки.Добавить("Изменение", Новый ОписаниеТипов("Булево"));
	ВидыПрав.Колонки.Добавить("АдминистрированиеИнформационнойБазы", Новый ОписаниеТипов("Булево"));
	ВидыПрав.Колонки.Добавить("АдминистрированиеОбластиДанных", Новый ОписаниеТипов("Булево"));
	
	Если ЭтоОбъектМетаданныхКонфигурация(ОбъектМетаданных) Тогда
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Администрирование";
		ВидПрава.АдминистрированиеИнформационнойБазы = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "АдминистрированиеДанных";
		ВидПрава.АдминистрированиеОбластиДанных = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ОбновлениеКонфигурацииБазыДанных";
		ВидПрава.АдминистрированиеИнформационнойБазы = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "МонопольныйРежим";
		ВидПрава.АдминистрированиеОбластиДанных = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "АктивныеПользователи";
		ВидПрава.АдминистрированиеОбластиДанных = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ЖурналРегистрации";
		ВидПрава.АдминистрированиеОбластиДанных = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ТонкийКлиент";
		ВидПрава.Интерактивное = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ВебКлиент";
		ВидПрава.Интерактивное = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ТолстыйКлиент";
		ВидПрава.АдминистрированиеИнформационнойБазы = Истина;
		ВидПрава.Интерактивное = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ВнешнееСоединение";
		ВидПрава.АдминистрированиеИнформационнойБазы = Истина;
		ВидПрава.Интерактивное = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Automation";
		ВидПрава.АдминистрированиеИнформационнойБазы = Истина;
		ВидПрава.Интерактивное = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "РежимВсеФункции";
		ВидПрава.АдминистрированиеИнформационнойБазы = Истина;
		ВидПрава.Интерактивное = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "СохранениеДанныхПользователя";
		ВидПрава.Интерактивное = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ИнтерактивноеОткрытиеВнешнихОбработок";
		ВидПрава.АдминистрированиеИнформационнойБазы = Истина;
		ВидПрава.Интерактивное = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ИнтерактивноеОткрытиеВнешнихОтчетов";
		ВидПрава.АдминистрированиеИнформационнойБазы = Истина;
		ВидПрава.Интерактивное = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Вывод";
		ВидПрава.Интерактивное = Истина;
		
	ИначеЕсли ЭтоПараметрСеанса(ОбъектМетаданных) Тогда
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Получение";
		ВидПрава.Чтение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Установка";
		ВидПрава.Изменение = Истина;
		
	ИначеЕсли ЭтоОбщийРеквизит(ОбъектМетаданных) Тогда
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава = "Просмотр";
		ВидПрава.Интерактивное = Истина;
		ВидПрава.Чтение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Редактирование";
		ВидПрава.Интерактивное = Истина;
		ВидПрава.Изменение = Истина;
		
	ИначеЕсли ЭтоКонстанта(ОбъектМетаданных) Тогда
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Чтение";
		ВидПрава.Чтение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Изменение";
		ВидПрава.Изменение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Просмотр";
		ВидПрава.Интерактивное = Истина;
		ВидПрава.Чтение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Редактирование";
		ВидПрава.Интерактивное = Истина;
		ВидПрава.Изменение = Истина;
		
	ИначеЕсли ЭтоСсылочныеДанные(ОбъектМетаданных) Тогда
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Чтение";
		ВидПрава.Чтение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Добавление";
		ВидПрава.Изменение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Изменение";
		ВидПрава.Изменение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Удаление";
		ВидПрава.Изменение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Просмотр";
		ВидПрава.Интерактивное = Истина;
		ВидПрава.Чтение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ИнтерактивноеДобавление";
		ВидПрава.Интерактивное = Истина;
		ВидПрава.Изменение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Редактирование";
		ВидПрава.Интерактивное = Истина;
		ВидПрава.Изменение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ИнтерактивноеУдаление";
		ВидПрава.Интерактивное = Истина;
		ВидПрава.Изменение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ИнтерактивнаяПометкаУдаления";
		ВидПрава.Интерактивное = Истина;
		ВидПрава.Изменение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ИнтерактивноеСнятиеПометкиУдаления";
		ВидПрава.Интерактивное = Истина;
		ВидПрава.Изменение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ИнтерактивноеУдалениеПомеченных";
		ВидПрава.Интерактивное = Истина;
		ВидПрава.Изменение = Истина;
		
		Если ЭтоДокумент(ОбъектМетаданных) Тогда
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "Проведение";
			ВидПрава.Изменение = Истина;
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "ОтменаПроведения";
			ВидПрава.Изменение = Истина;
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "ИнтерактивноеПроведение";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Изменение = Истина;
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "ИнтерактивноеПроведениеНеоперативное";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Изменение = Истина;
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "ИнтерактивнаяОтменаПроведения";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Изменение = Истина;
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "ИнтерактивноеИзменениеПроведенных";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Изменение = Истина;
			
		КонецЕсли;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "ВводПоСтроке";
		ВидПрава.Интерактивное = Истина;
		ВидПрава.Чтение = Истина;
		
		Если ЭтоБизнесПроцесс(ОбъектМетаданных) Тогда
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "ИнтерактивнаяАктивация";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Изменение = Истина;
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "Старт";
			ВидПрава.Изменение = Истина;
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "ИнтерактивныйСтарт";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Изменение = Истина;
			
		КонецЕсли;
		
		Если ЭтоЗадача(ОбъектМетаданных) Тогда
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "ИнтерактивнаяАктивация";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Изменение = Истина;
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "Выполнение";
			ВидПрава.Изменение = Истина;
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "ИнтерактивноеВыполнение";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Изменение = Истина;
			
		КонецЕсли;
		
		Если ЭтоСсылочныеДанныеПоддерживающиеПредопределенныеЭлементы(ОбъектМетаданных) Тогда
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "ИнтерактивноеУдалениеПредопределенныхДанных";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Изменение = Истина;
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "ИнтерактивнаяПометкаУдаленияПредопределенныхДанных";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Изменение = Истина;
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "ИнтерактивноеСнятиеПометкиУдаленияПредопределенныхДанных";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Изменение = Истина;
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "ИнтерактивноеУдалениеПомеченныхПредопределенныхДанных";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Изменение = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ЭтоНаборЗаписей(ОбъектМетаданных) Тогда
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Чтение";
		ВидПрава.Чтение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Изменение";
		ВидПрава.Изменение = Истина;
		
		Если Не ЭтоНаборЗаписейПоследовательности(ОбъектМетаданных) И Не ЭтоНаборЗаписейПерерасчета(ОбъектМетаданных) Тогда
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "Просмотр";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Чтение = Истина;
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "Редактирование";
			ВидПрава.Интерактивное = Истина;
			ВидПрава.Изменение = Истина;
			
		КонецЕсли;
		
		Если ЭтоНаборЗаписейПоддерживающийИтоги(ОбъектМетаданных) Тогда
			
			ВидПрава = ВидыПрав.Добавить();
			ВидПрава.Имя = "УправлениеИтогами";
			ВидПрава.АдминистрированиеОбластиДанных = Истина;
			
		КонецЕсли;
		
	ИначеЕсли ЭтоЖурналДокументов(ОбъектМетаданных) Тогда
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Чтение";
		ВидПрава.Чтение = Истина;
		
		ВидПрава = ВидыПрав.Добавить();
		ВидПрава.Имя = "Просмотр";
		ВидПрава.Интерактивное = Истина;
		ВидПрава.Чтение = Истина;
		
	КонецЕсли;
	
	Возврат ВидыПрав;
	
КонецФункции

// Возвращает пустой уникальный идентификатор.
//
// Возвращаемое значение:
//  УникальныйИдентификатор - уникальный идентификатор.
//
Функция ПустойУникальныйИдентификатор() Экспорт
	
	Возврат Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	
КонецФункции

// Останавливает выполнение кода на заданное время.
// Использовать можно только в фоновом задании.
//
// Параметры:
//  Секунд - Число - время ожидания в секундах.
//
Процедура Пауза(Секунд) Экспорт
	
	ТекущийСеансИнформационнойБазы = ПолучитьТекущийСеансИнформационнойБазы();
	ФоновоеЗадание = ТекущийСеансИнформационнойБазы.ПолучитьФоновоеЗадание();
	
	Если ФоновоеЗадание = Неопределено Тогда
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Ошибка выполнения'"), 
			УровеньЖурналаРегистрации.Ошибка, 
			, 
			, 
			НСтр("ru = 'ОбщегоНазначенияБТС.Пауза() разрешается использовать только в фоновом задании.'"));
		Параметры = Новый Массив;
		Параметры.Добавить(Секунд);
		ФоновоеЗадание = ФоновыеЗадания.Выполнить("ОбщегоНазначенияБТС.Пауза", Параметры);
	КонецЕсли;
		
	ФоновоеЗадание.ОжидатьЗавершенияВыполнения(Секунд);
	
КонецПроцедуры

// Записывает событие в технологический журнал.
//
// Параметры:
//  Событие	 - Строка - имя события для фильтрации записей технологического журнала с помощью настроек logcfg.xml.
//  Контекст - Структура - Произвольные данные для записи в технологический журнал.
//		В значения рекомендуется помещать данные примитивных типов. Это позволит повысить скорость записи.
//
Процедура ЗаписьТехнологическогоЖурнала(Событие, Контекст) Экспорт
	
	Попытка
		
		Запись = Новый ЗаписьJSON;
		Запись.УстановитьСтроку();
		
		Попытка
			
			ЗаписатьJSON(Запись, Контекст);
			
		Исключение
		
			СериализаторXDTO.ЗаписатьJSON(Запись, Контекст);
			
		КонецПопытки;
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	&Событие КАК Событие,
		|	&Контекст КАК Контекст");
		
		Запрос.УстановитьПараметр("Событие", "СобытиеТЖ." + Событие);
		Запрос.УстановитьПараметр("Контекст", Запись.Закрыть());
		
		Запрос.Выполнить();
		
	Исключение
		
		ЗаписьЖурналаРегистрации("ЗаписьТехнологическогоЖурнала", УровеньЖурналаРегистрации.Ошибка,,, 
			ТехнологияСервиса.ПодробныйТекстОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Активные расширения изменяющие структуру данных.
// 
// Возвращаемое значение:
//  Массив из РасширениеКонфигурации
Функция АктивныеРасширенияИзменяющиеСтруктуруДанных() Экспорт
	
	АктивныеРасширенияИзменяющиеСтруктуруДанных = Новый Массив;
	
	Для Каждого РасширениеКонфигурации Из РасширенияКонфигурации.Получить(, ИсточникРасширенийКонфигурации.СеансАктивные) Цикл	
		Если РасширениеКонфигурации.Активно
			И РасширениеКонфигурации.ИзменяетСтруктуруДанных() Тогда
			АктивныеРасширенияИзменяющиеСтруктуруДанных.Добавить(РасширениеКонфигурации)
		КонецЕсли;
	КонецЦикла;
	
	Возврат АктивныеРасширенияИзменяющиеСтруктуруДанных;
КонецФункции

// Параметры: 
//  Строка - Строка - исходная строка.
// 
// Возвращаемое значение: 
//  Строка - только цифры из строки
Функция ТолькоЦифры(Знач Строка) Экспорт
	
	ОбработаннаяСтрока = "";

	Для НомерСимвола = 1 По СтрДлина(Строка) Цикл
		Символ = Сред(Строка, НомерСимвола, 1);
		Если Символ >= "0" И Символ <= "9" Тогда
			ОбработаннаяСтрока = ОбработаннаяСтрока + Символ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОбработаннаяСтрока;
	
КонецФункции

// Получает значение заголовка регистронезависимо.
//
// Параметры: 
//  ЗапросОтвет - HTTPЗапрос, HTTPОтвет, HTTPСервисЗапрос, HTTPСервисОтвет - запрос или ответ.
//  Заголовок - Строка - имя заголовка.
//
// Возвращаемое значение:
//  Строка, Неопределено - значение заголовка.
//
Функция ЗаголовокHTTP(ЗапросОтвет, Знач Заголовок) Экспорт
	
	Заголовок = НРег(Заголовок);
	Для Каждого КлючИЗначение Из ЗапросОтвет.Заголовки Цикл
		Если НРег(КлючИЗначение.Ключ) = Заголовок Тогда
			Возврат КлючИЗначение.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

// Возвращаемое значение:
//  Массив из Строка -
//
Функция ИменаИнтерактивныхПриложений() Экспорт
	ИменаПриложений = Новый Массив();
	ИменаПриложений.Добавить("1CV8");
	ИменаПриложений.Добавить("1CV8C");
	ИменаПриложений.Добавить("WebClient");
	ИменаПриложений.Добавить("MobileClient");
	Возврат ИменаПриложений;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет, содержит ли конфигурация БСП.
//
// Возвращаемое значение:
//   Булево - результат.
//
Функция КонфигурацияСодержитБСП()
	
	Возврат (Метаданные.Подсистемы.Найти("СтандартныеПодсистемы") <> Неопределено);
	
КонецФункции

// Проверяет, поддерживаются ли в текущей конфигурации программные события БСП.
//
// Возвращаемое значение:
//   Булево - поддержка событий БТС. 
//
Функция ПоддерживаютсяПрограммныеСобытия()
	
	Если Не КонфигурацияСодержитБСП() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		
		УстановитьБезопасныйРежим(Истина);
		
		Выполнить("СтандартныеПодсистемыПовтИсп.ПараметрыПрограммныхСобытий()");
		Возврат Истина;
		
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

// (Устарел) Возвращает обработчики программных событий БСП.
//
// Параметры:
//  Событие - Строка - имя события.
// Возвращаемое значение:
//	Массив из Произвольный - обработчики.
Функция ПолучитьОбработчикиПрограммныхСобытийБСП(Знач Событие) Экспорт
	
	Если ПоддерживаютсяПрограммныеСобытия() Тогда
		
		УстановитьБезопасныйРежим(Истина);
		Возврат Вычислить("ОбщегоНазначения.ОбработчикиСлужебногоСобытия(Событие)");
		
	Иначе
		Возврат Новый Массив();
	КонецЕсли;
	
КонецФункции

// Свойства объекта модели конфигурации
// 
// Параметры: 
//  Модель - ФиксированныйМассив из Структура:
//  * Значение - Соответствие из КлючИЗначение:
//  		   - ФиксированноеСоответствие Из КлючИЗначение:
//  			  * Ключ - Строка
//  			  * Значение - см. ОбщегоНазначенияБТСПовтИсп.НовыйОписаниеОбъекта
//  ОбъектМетаданных - ОбъектМетаданных - Объект метаданных
// 
// Возвращаемое значение:  см. ОбщегоНазначенияБТСПовтИсп.НовыйОписаниеОбъекта
//
Функция СвойстваОбъектаМоделиКонфигурации(Знач Модель, Знач ОбъектМетаданных) Экспорт
	
	Если ТипЗнч(ОбъектМетаданных) = Тип("ОбъектМетаданных") Тогда
		Имя = ОбъектМетаданных.Имя;
		ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
	Иначе
		ПолноеИмя = ОбъектМетаданных;
		Имя = СтрРазделить(ПолноеИмя, ".").Получить(1);
	КонецЕсли;
	
	Для Каждого КлассМодели Из Модель Цикл
		Значение = КлассМодели.Значение;
		Если ТипЗнч(Значение) = Тип("Соответствие")  Или ТипЗнч(Значение) = Тип("ФиксированноеСоответствие") Тогда
			ОписаниеОбъекта = Значение.Получить(Имя); // см. ОбщегоНазначенияБТСПовтИсп.НовыйОписаниеОбъекта
		Иначе
			ОписаниеОбъекта = Неопределено;
		КонецЕсли;
		Если ОписаниеОбъекта <> Неопределено Тогда
			Если ПолноеИмя = ОписаниеОбъекта.ПолноеИмя Тогда
				Возврат ОписаниеОбъекта;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти