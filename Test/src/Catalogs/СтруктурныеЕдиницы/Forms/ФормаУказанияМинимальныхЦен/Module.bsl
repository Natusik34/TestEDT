
#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимУказанияМинимальныхЦен = ПолучитьТекущийРежимУказанияМинимальныхЦен();
	ОбщийВидМинимальныхЦен = ЦенообразованиеСерверПовтИсп.ПолучитьОбщийВидМинимальныхЦен();
	
	Если РежимУказанияМинимальныхЦен = "ПоСтруктурнымЕдиницам" Тогда  		
		ЗаполнитьДеревоСтруктурныхЕдиниц();                           		
	КонецЕсли;  	
			
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	УстановитьВидимостьСтраницНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область СобытияЭлементовФормы

&НаКлиенте
Процедура ДеревоПодразделенийМинимальныйВидЦенПриИзменении(Элемент)
	
	ДеревоПодразделенийМинимальныйВидЦенПриИзмененииНаСервере(Элементы.ДеревоПодразделений.ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура РежимУказанияМинимальныхЦенПриИзменении(Элемент)
	
	ОбработатьИзменениеРежимаУказания();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбщийВидМинимальныхЦенПриИзменении(Элемент)
	
	ЦенообразованиеСервер.УстановитьВидМинимальныхЦен(Неопределено, ОбщийВидМинимальныхЦен);
	ЗаполнитьДеревоСтруктурныхЕдиниц();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДеревоПодразделенийМинимальныйВидЦенПриИзмененииНаСервере(Идентификатор)
	УстановитьМинимальныеЦеныПоСкладу(Идентификатор);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоСтруктурныхЕдиниц() 
	
	Дерево = РеквизитФормыВЗначение("ДеревоСтруктурныхЕдиниц");
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	СтруктурныеЕдиницы.Ссылка КАК Подразделение,
	               |	ВЫБОР
	               |		КОГДА НЕ СтруктурныеЕдиницы.ПометкаУдаления
	               |			ТОГДА ВЫБОР
	               |					КОГДА СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.МагазинГруппаСкладов)
	               |						ТОГДА 0
	               |					КОГДА СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Подразделение)
	               |						ТОГДА 1
	               |					КОГДА СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Склад)
	               |						ТОГДА 2
	               |					КОГДА СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница)
	               |						ТОГДА 3
	               |					КОГДА СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.РозницаСуммовойУчет)
	               |						ТОГДА 4
	               |				КОНЕЦ
	               |		ИНАЧЕ ВЫБОР
	               |				КОГДА СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.МагазинГруппаСкладов)
	               |					ТОГДА 5
	               |				КОГДА СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Подразделение)
	               |					ТОГДА 6
	               |				КОГДА СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Склад)
	               |					ТОГДА 7
	               |				КОГДА СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница)
	               |					ТОГДА 8
	               |				КОГДА СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы = ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.РозницаСуммовойУчет)
	               |					ТОГДА 9
	               |			КОНЕЦ
	               |	КОНЕЦ КАК ВариантКартинки,
	               |	"""" КАК Отступ,
	               |	ВЫБОР
	               |		КОГДА ВидыМинимальныхЦенСтруктурныхЕдиниц.ВидМинимальныхЦен ЕСТЬ NULL
	               |				ИЛИ ВидыМинимальныхЦенСтруктурныхЕдиниц.ВидМинимальныхЦен = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	               |			ТОГДА ОбщийВидМинимальныхЦен.ВидМинимальныхЦен
	               |		ИНАЧЕ ВидыМинимальныхЦенСтруктурныхЕдиниц.ВидМинимальныхЦен
	               |	КОНЕЦ КАК ВидМинимальныхЦен,
	               |	ВЫБОР
	               |		КОГДА ВидыМинимальныхЦенСтруктурныхЕдиниц.ВидМинимальныхЦен ЕСТЬ NULL
	               |				ИЛИ ВидыМинимальныхЦенСтруктурныхЕдиниц.ВидМинимальныхЦен = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК ВидМинимальныхЦенПоУмолчанию,
	               |	ВЫБОР
	               |		КОГДА СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы В (ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Склад), ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница), ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.РозницаСуммовойУчет))
	               |			ТОГДА ИСТИНА
	               |		ИНАЧЕ ЛОЖЬ
	               |	КОНЕЦ КАК МожноУказатьМинимальныеЦены
	               |ИЗ
	               |	Справочник.СтруктурныеЕдиницы КАК СтруктурныеЕдиницы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВидыМинимальныхЦенСтруктурныхЕдиниц КАК ВидыМинимальныхЦенСтруктурныхЕдиниц
	               |		ПО (ВидыМинимальныхЦенСтруктурныхЕдиниц.СтруктурнаяЕдиница = СтруктурныеЕдиницы.Ссылка)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВидыМинимальныхЦенСтруктурныхЕдиниц КАК ОбщийВидМинимальныхЦен
	               |		ПО (ОбщийВидМинимальныхЦен.СтруктурнаяЕдиница = ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка))
	               |ГДЕ
	               |	СтруктурныеЕдиницы.ТипСтруктурнойЕдиницы В (ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Склад), ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.Розница), ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.РозницаСуммовойУчет), ЗНАЧЕНИЕ(Перечисление.ТипыСтруктурныхЕдиниц.МагазинГруппаСкладов))
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	СтруктурныеЕдиницы.Наименование ИЕРАРХИЯ
	               |АВТОУПОРЯДОЧИВАНИЕ";
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗначениеВДанныеФормы(Дерево, ДеревоСтруктурныхЕдиниц);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекущийРежимУказанияМинимальныхЦен()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ИСТИНА КАК ЕстьНастройки
	               |ИЗ
	               |	РегистрСведений.ВидыМинимальныхЦенСтруктурныхЕдиниц КАК ВидыМинимальныхЦенСтруктурныхЕдиниц
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ИСТИНА КАК ПоСтруктурнымЕдиницам
	               |ИЗ
	               |	РегистрСведений.ВидыМинимальныхЦенСтруктурныхЕдиниц КАК ВидыМинимальныхЦенСтруктурныхЕдиниц
	               |ГДЕ
	               |	ВидыМинимальныхЦенСтруктурныхЕдиниц.СтруктурнаяЕдиница <> ЗНАЧЕНИЕ(Справочник.СтруктурныеЕдиницы.ПустаяСсылка)";
	Результат = Запрос.ВыполнитьПакет();
	Если Результат[0].Пустой() Тогда
		Возврат "ОбщийДляВсех";                             
	КонецЕсли;           	
	Если Результат[1].Пустой() Тогда
		Возврат "ОбщийДляВсех";
	Иначе
		Возврат "ПоСтруктурнымЕдиницам";
	КонецЕсли; 	
	
КонецФункции

&НаСервере
Процедура УстановитьМинимальныеЦеныПоСкладу(Идентификатор)
	
	ТекущиеДанные = ДеревоСтруктурныхЕдиниц.НайтиПоИдентификатору(Идентификатор);
	Если ЗначениеЗаполнено(ТекущиеДанные.ВидМинимальныхЦен) Тогда
		ЦенообразованиеСервер.УстановитьВидМинимальныхЦен(ТекущиеДанные.Подразделение, ТекущиеДанные.ВидМинимальныхЦен);
		ТекущиеДанные.ВидМинимальныхЦенПоУмолчанию = Ложь;
	Иначе
		ЦенообразованиеСервер.УдалитьВидМинимальныхЦен(ТекущиеДанные.Подразделение);
		ТекущиеДанные.ВидМинимальныхЦен = ОбщийВидМинимальныхЦен;
		ТекущиеДанные.ВидМинимальныхЦенПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьСтраницНастройки()
	
	Если РежимУказанияМинимальныхЦен = "ОбщийДляВсех" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСтраницаОбщийДляВсех", "Видимость", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСтраницаПоСтруктурнымЕдиницам", "Видимость", Ложь);
	ИначеЕсли РежимУказанияМинимальныхЦен = "ПоСтруктурнымЕдиницам" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСтраницаОбщийДляВсех", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаСтраницаПоСтруктурнымЕдиницам", "Видимость", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеРежимаУказания()
	
	Если РежимУказанияМинимальныхЦен = "ОбщийДляВсех" Тогда
		
		ТекущийРежимУказанияМинимальныхЦен = ПолучитьТекущийРежимУказанияМинимальныхЦен();
		Если ТекущийРежимУказанияМинимальныхЦен = "ПоСтруктурнымЕдиницам" Тогда
			
			ДополнительныеПараметры = Новый Структура("ОчищатьНастройки", Истина);
			ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияВопросаПереключенияРежимаУказания", ЭтаФорма, ДополнительныеПараметры);
			ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Настройки минимальных цен по структурным единицам будут очищены. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
			
		Иначе
			
			УстановитьВидимостьСтраницНастройки();
			
		КонецЕсли;
		
	ИначеЕсли РежимУказанияМинимальныхЦен = "ПоСтруктурнымЕдиницам" Тогда
		
		ЗаполнитьДеревоСтруктурныхЕдиниц();
		УстановитьВидимостьСтраницНастройки();
		
	КонецЕсли;   	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаПереключенияРежимаУказания(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		РежимУказанияМинимальныхЦен = "ПоСтруктурнымЕдиницам";
		Возврат;
	КонецЕсли;
	
	ОчиститьНастройкиИУстановитьОбщийВидЦен();
	УстановитьВидимостьСтраницНастройки();
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьНастройкиИУстановитьОбщийВидЦен()
	
	НачатьТранзакцию();
	
	Попытка
		
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.ВидыМинимальныхЦенСтруктурныхЕдиниц");
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
		
		ОбщийВидМинимальныхЦен = ЦенообразованиеСерверПовтИсп.ПолучитьОбщийВидМинимальныхЦен();
		Набор = РегистрыСведений.ВидыМинимальныхЦенСтруктурныхЕдиниц.СоздатьНаборЗаписей();
		Набор.Прочитать();
		Набор.Очистить();
		Набор.Записать(Истина);
		ЦенообразованиеСервер.УстановитьВидМинимальныхЦен(Неопределено, ОбщийВидМинимальныхЦен);
		
		ЗафиксироватьТранзакцию();
		
	Исключение

		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка очистка регистра видов минимальных цен'", ОбщегоНазначения.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти