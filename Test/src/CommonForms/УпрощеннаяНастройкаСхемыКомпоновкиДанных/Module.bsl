
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Переданный в параметре адрес сохраняется в качестве адреса исходной схемы.
	АдресИсходнойСхемыКомпоновкиДанных = Параметры.АдресСхемыКомпоновкиДанных;
	УникальныйИдентификаторВладельца = Новый УникальныйИдентификатор;
	
	// Заголовок формы
	Заголовок = Параметры.Заголовок;
	
	// Исходная схема компоновки данных копируется в редактируемую схему компоновки данных.
	СкопироватьСхемуКомпоновкиДанных(АдресРедактируемойСхемыКомпоновкиДанных, АдресИсходнойСхемыКомпоновкиДанных);
	
	// Компоновщик настроек инициализируется редактируемой схемой компоновки данных.
	ИнициализироватьКомпоновщикНастроек(КомпоновщикНастроек, АдресРедактируемойСхемыКомпоновкиДанных, Параметры.АдресНастроекКомпоновкиДанных);
	
	Элементы.РедактироватьСхемуКомпоновки.Видимость = Параметры.РедактироватьСхемуКомпоновкиДанных;
	Элементы.ЗагрузитьСхемуИзФайла.Видимость 		= Параметры.ЗагрузитьСхемуИзФайла;
	Элементы.ГруппаОтбор.Видимость                  = Параметры.НастраиватьОтбор;
	Элементы.ГруппаПараметры.Видимость              = Параметры.НастраиватьПараметры;
	Элементы.ГруппаПорядок.Видимость                = Параметры.НастраиватьПорядок;
	Элементы.ГруппаУсловноеОформление.Видимость     = Параметры.НастраиватьУсловноеОформление;
	Элементы.ГруппаПоля.Видимость                   = Параметры.НастраиватьВыбор;
	
	ПомещатьНастройкиВСхемуКомпоновкиДанных = Параметры.ПомещатьНастройкиВСхемуКомпоновкиДанных;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
		
		// Получена схема из конструктора схемы компоновки данных.
		Модифицированность = Истина;
		РедактируемаяСхемаКомпоновкиДанныхМодифицированность = Истина;
		
		// Редактируемая схема компоновки данных замещается схемой, полученной из конструктора.
		БылиИзменения = Ложь;
		УстановитьСхемуКомпоновкиДанных(АдресРедактируемойСхемыКомпоновкиДанных, ВыбранноеЗначение, Истина, БылиИзменения);
		
		// Компоновщик настроек инициализируется редактируемой схемой.
		ИнициализироватьКомпоновщикНастроек(КомпоновщикНастроек, АдресРедактируемойСхемыКомпоновкиДанных);
		
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ОчиститьСообщения();
	Если НЕ ОбязательныеПараметрыСКДЗаполнены() Тогда
		Возврат;
	КонецЕсли;
	
	Если РедактируемаяСхемаКомпоновкиДанныхМодифицированность Тогда
		
		// Исходная схема замещается редактируемой схемой.
		УстановитьСхемуКомпоновкиДанных(АдресИсходнойСхемыКомпоновкиДанных, АдресРедактируемойСхемыКомпоновкиДанных);
		
	Иначе
		
		// Настройки компоновщика настроек помещаются в исходную схему.
		ПоместитьНастройкиВСхемуКомпоновкиДанных(КомпоновщикНастроек, АдресИсходнойСхемыКомпоновкиДанных);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(УникальныйИдентификаторВладельца) Тогда
		Закрыть(ПолучитьНастройкиКомпоновщика(КомпоновщикНастроек, УникальныйИдентификаторВладельца));
	Иначе
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСхемуКомпоновки(Команда)
	
	ОткрытьКонструкторСхемыКомпоновкиДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайла(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗагрузитьСхемуИзФайлаРасширениеПодключено",
		ЭтотОбъект);
	
	НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьКонструкторСхемыКомпоновкиДанных()
	
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
		
		// Создается копия редактируемой схемы.
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXDTO(СериализаторXDTO.ЗаписатьXDTO(ПолучитьИзВременногоХранилища(АдресРедактируемойСхемыКомпоновкиДанных)));
		
		// Копия редактируемой схемы открывается в конструкторе.
		Конструктор = Новый КонструкторСхемыКомпоновкиДанных(СхемаКомпоновкиДанных);
		Конструктор.Редактировать(ЭтаФорма);
		
	#Иначе
		
		ПоказатьПредупреждение(, НСтр("ru='Для того, чтобы редактировать схему компоновки, необходимо запустить конфигурацию в режиме толстого клиента.'"));
		
	#КонецЕсли
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьСхемуКомпоновкиДанных(АдресПриемник, АдресСхемаИсточник, ПроверятьНаИзменение = Ложь, БылиИзменения = Ложь)
	
	Если ЭтоАдресВременногоХранилища(АдресСхемаИсточник) Тогда
		
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемаИсточник);
		
	Иначе
		
		СхемаКомпоновкиДанных = АдресСхемаИсточник;
		
	КонецЕсли;
	
	Если ПроверятьНаИзменение Тогда
		
		БылиИзменения = Ложь;
		
		Если ЭтоАдресВременногоХранилища(АдресПриемник) Тогда
			
			ТекущаяСКД = ПолучитьИзВременногоХранилища(АдресПриемник);
			Если ТипЗнч(ТекущаяСКД) = Тип("СхемаКомпоновкиДанных") Тогда
				
				Если ЦенообразованиеСервер.ПолучитьXML(СхемаКомпоновкиДанных) <> ЦенообразованиеСервер.ПолучитьXML(ТекущаяСКД) Тогда
					
					БылиИзменения = Истина;
					
				КонецЕсли
				
			Иначе
				
				БылиИзменения = Истина;
				
			КонецЕсли;
			
		Иначе
			
			БылиИзменения = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(АдресПриемник) Тогда
		
		ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресПриемник);
		
	Иначе
		
		АдресПриемник = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьСхемуКомпоновкиДанных(АдресПриемник, АдресИсточник)
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресИсточник);
	
	Если ТипЗнч(СхемаКомпоновкиДанных) = Тип("СхемаКомпоновкиДанных") Тогда
		
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXDTO(СериализаторXDTO.ЗаписатьXDTO(СхемаКомпоновкиДанных));
		
	Иначе
		
		СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
		
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(АдресПриемник) Тогда
		
		ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресПриемник);
		
	Иначе
		
		АдресПриемник = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИнициализироватьКомпоновщикНастроек(КомпоновщикНастроек, АдресСхемыКомпоновкиДанных, АдресНастроекКомпоновкиДанных = Неопределено)
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	Если ЗначениеЗаполнено(АдресНастроекКомпоновкиДанных) Тогда
		НастройкиКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресНастроекКомпоновкиДанных);
	КонецЕсли;
	
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	Исключение
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Если ЗначениеЗаполнено(АдресНастроекКомпоновкиДанных) Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновкиДанных);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	
	КомпоновщикНастроек.Восстановить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНастройкиКомпоновщика(КомпоновщикНастроек, УникальныйИдентификатор)
	
	КомпоновщикНастроек.Восстановить();
	
	Возврат ПоместитьВоВременноеХранилище(КомпоновщикНастроек.ПолучитьНастройки(), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Функция ОбязательныеПараметрыСКДЗаполнены()
	
	ВсеВерно = Истина;
	
	НастройкиСКД = КомпоновщикНастроек.Настройки;
	СписокПараметровСКД = НастройкиСКД.ПараметрыДанных.Элементы;
	ИндексПараметра = 0;
	Для Каждого ПараметрСКД Из СписокПараметровСКД Цикл
		Если ТипЗнч(ПараметрСКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
			ПараметрНастроек = КомпоновщикНастроек.Настройки.ПараметрыДанных.ДоступныеПараметры.НайтиПараметр(ПараметрСКД.Параметр);
			Если ПараметрНастроек <> Неопределено И ПараметрНастроек.ЗапрещатьНезаполненныеЗначения Тогда
				Если (НЕ ПараметрСКД.Использование) ИЛИ (НЕ ЗначениеЗаполнено(ПараметрСКД.Значение)) Тогда
					ЭтаФорма.Элементы.ГруппаСтраницы.ТекущаяСтраница = ЭтаФорма.Элементы.ГруппаПараметры;
					ТекстСообщения = НСтр("ru = 'Не заполнено значение обязательного параметра ""%1""'");
					ИмяПараметраСКД = ?(ЗначениеЗаполнено(ПараметрСКД.ПредставлениеПользовательскойНастройки),
											ПараметрСКД.ПредставлениеПользовательскойНастройки,
											?(ЗначениеЗаполнено(ПараметрНастроек.Заголовок),
																ПараметрНастроек.Заголовок,
																ПараметрНастроек.Имя));
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ИмяПараметраСКД);
					Поле = "КомпоновщикНастроек.Настройки.ПараметрыДанных";
					ОбщегоНазначения.СообщитьПользователю(
						ТекстСообщения,
						,
						Поле,
						,
						Ложь);
					ВсеВерно = Ложь;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ИндексПараметра = ИндексПараметра + 1;
	КонецЦикла;
	
	Возврат ВсеВерно;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзмененаСхемаКомпоновкиДанных(Форма, СхемаКомпоновкиДанных)
	
	// Получена схема из конструктора схемы компоновки данных
	Форма.Модифицированность = Истина;
	Форма.РедактируемаяСхемаКомпоновкиДанныхМодифицированность = Истина;
	
	// Редактируемая схема компоновки данных замещается схемой, полученной из конструктора.
	БылиИзменения = Ложь;
	
	УстановитьСхемуКомпоновкиДанных(Форма.АдресРедактируемойСхемыКомпоновкиДанных, СхемаКомпоновкиДанных, Истина, БылиИзменения);
	
	// Компоновщик настроек инициализируется редактируемой схемой
	ИнициализироватьКомпоновщикНастроек(Форма.КомпоновщикНастроек,
	                                    Форма.АдресРедактируемойСхемыКомпоновкиДанных);
	
КонецПроцедуры

#Область ЗагрузкаСхемыИзФайла

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайлаРасширениеПодключено(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ВыборФайла.ПолноеИмяФайла = "";
		ВыборФайла.Заголовок = НСтр("ru = 'Выбор схемы компоновки данных'");
		ВыборФайла.Фильтр = НСтр("ru = 'Схема компоновки данных (*.xml)|*.xml'");
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ЗагрузитьСхемуИзФайлаВыборФайла",
			ЭтотОбъект);
		
		ФайловаяСистемаКлиент.ПоказатьДиалогВыбора(ОписаниеОповещения, ВыборФайла);
		
	Иначе
		
		#Если ВебКлиент Тогда
			
			АдресФайлаВоВременномХранилище = "";
			ИмяФайла = ""; 
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьСхемуИзФайлаЗавершение",ЭтотОбъект,Новый Структура("АдресФайлаВоВременномХранилище", АдресФайлаВоВременномХранилище));
			
			ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
			ПараметрыЗагрузки.ИдентификаторФормы = ЭтотОбъект.УникальныйИдентификатор;
			ФайловаяСистемаКлиент.ЗагрузитьФайл(ОписаниеОповещения, ПараметрыЗагрузки, ИмяФайла, АдресФайлаВоВременномХранилище); 
			
		#КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайлаВыборФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТекстовыйДокумент", ТекстовыйДокумент);
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗагрузитьСхемуИзФайлаВыборФайлаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстовыйДокумент.НачатьЧтение(ОповещениеОЗавершении, ВыбранныеФайлы[0], КодировкаТекста.UTF8);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайлаВыборФайлаЗавершение(ДополнительныеПараметры) Экспорт
	
	ТекстовыйДокумент = ДополнительныеПараметры.ТекстовыйДокумент;
	
	Текст = ТекстовыйДокумент.ПолучитьТекст();
	
	ОчиститьСообщения();
	ЗагрузитьСхемуИзФайлаНаСервере(Текст);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайлаЗавершение(Результат, Адрес, ИмяФайла, ДополнительныеПараметры) Экспорт
	
	АдресФайлаВоВременномХранилище = ДополнительныеПараметры.АдресФайлаВоВременномХранилище;
	
	Если НЕ Результат Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	ЗагрузитьСхемуИзФайлаНаСервереВеб(АдресФайлаВоВременномХранилище);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСхемуИзФайлаНаСервере(ТекстXML)
	
	Попытка
		
		ЧтениеXML = Новый ЧтениеXML();
		ЧтениеXML.УстановитьСтроку(ТекстXML);
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
		ИзмененаСхемаКомпоновкиДанных(ЭтаФорма, СхемаКомпоновкиДанных);
		
	Исключение
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение операции'", ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,,,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСхемуИзФайлаНаСервереВеб(АдресФайлаВоВременномХранилище)
	
	Попытка
		
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВоВременномХранилище);
		
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ИмяВременногоФайла, КодировкаТекста.UTF8);
		ТекстXML = ТекстовыйДокумент.ПолучитьТекст();
		
		ЧтениеXML = Новый ЧтениеXML();
		ЧтениеXML.УстановитьСтроку(ТекстXML);
		
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
		ИзмененаСхемаКомпоновкиДанных(ЭтаФорма, СхемаКомпоновкиДанных);
		
		УдалитьФайлы(ИмяВременногоФайла);
		
	Исключение		
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Выполнение операции'", ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,,,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())); 	
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПоместитьНастройкиВСхемуКомпоновкиДанных(КомпоновщикНастроек, АдресСхемыКомпоновкиДанных)
	
	КомпоновщикНастроек.Восстановить();
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	РаботаССегментами.ОчиститьНастройкиКомпоновкиДанных(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	РаботаССегментами.СкопироватьНастройкиКомпоновкиДанных(СхемаКомпоновкиДанных.НастройкиПоУмолчанию, КомпоновщикНастроек.Настройки);
	
	ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресСхемыКомпоновкиДанных);
	
КонецПроцедуры
#КонецОбласти

#КонецОбласти
