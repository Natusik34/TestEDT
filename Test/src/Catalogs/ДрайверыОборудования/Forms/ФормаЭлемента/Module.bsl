#Область ОбработчикиСобытийФорм

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СозданиеНового = НЕ ЗначениеЗаполнено(Объект.Ссылка);
	
	Если СозданиеНового Тогда
		Объект.СпособПодключения = Перечисления.СпособПодключенияДрайвера.ЛокальноПоИдентификатору;
		Элементы.ИдентификаторОбъекта.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
	Иначе                                                   
		
		ДанныеДрайвера = МенеджерОборудования.ДанныеДрайвераОборудования(Объект.Ссылка);
		
		ПоставляемыйВСоставеКонфигурации = Объект.Предопределенный;
		ПодключениеЛокальноПоИдентификатору = Объект.СпособПодключения = Перечисления.СпособПодключенияДрайвера.ЛокальноПоИдентификатору;
		ПодключениеИзИнформационнойБазы     = Объект.СпособПодключения = Перечисления.СпособПодключенияДрайвера.ИзИнформационнойБазы;
		ПодключениеИзМакета                 = Объект.СпособПодключения = Перечисления.СпособПодключенияДрайвера.ИзМакета;
		
		Элементы.ФормаОбновитьДрайверИзФайла.Видимость = ПодключениеИзИнформационнойБазы;
		Элементы.СнятСПоддержки.Видимость = Объект.СнятСПоддержки;
		Элементы.МакетНеДоступен.Видимость = ПодключениеИзМакета И НЕ ДанныеДрайвера.МакетДоступен И НЕ ПустаяСтрока(Объект.ИдентификаторОбъекта);
		
		Если ПоставляемыйВСоставеКонфигурации Тогда
			РежимРаботы = РежимРаботы + НСтр("ru = 'Локальный'");
		КонецЕсли;
		Элементы.ИдентификаторОбъекта.ОтображениеПодсказки = ОтображениеПодсказки.Всплывающая;
		
		СвойстваТолькоПросмотр =  ПоставляемыйВСоставеКонфигурации И Не ПодключениеЛокальноПоИдентификатору;
		Элементы.ТипОборудования.ТолькоПросмотр = СвойстваТолькоПросмотр;
		Элементы.Наименование.ТолькоПросмотр    = СвойстваТолькоПросмотр;
		Элементы.ИдентификаторОбъекта.ТолькоПросмотр = СвойстваТолькоПросмотр;
		Элементы.ФормаЗаписатьИЗакрыть.Видимость     = Не СвойстваТолькоПросмотр;
	КонецЕсли;
	
	Если Элементы.МакетНеДоступен.Видимость Тогда
		Элементы.МакетНеДоступен.Заголовок = Элементы.МакетНеДоступен.Заголовок + Символы.НПП + ДанныеДрайвера.ИмяМакетаДрайвера;
	КонецЕсли;
	
	Элементы.ВерсияДрайвера.Видимость = Не ПустаяСтрока(Объект.ВерсияДрайвера);
	Элементы.УстановленнаяВерсия.Видимость = Ложь;
	Элементы.ГруппаЛог.Видимость = Ложь;

	Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = Не Элементы.ФормаЗаписатьИЗакрыть.Видимость; 
		
	ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.Наименование);
	ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.ТипОборудования);
	ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.СпособПодключения);
	ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.РежимРаботы);
	ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.ИдентификаторОбъекта);
	ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.ВерсияДрайвера);
	ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.ТекущийСтатус);
	ОбщегоНазначенияБПО.ПодготовитьЭлементУправления(Элементы.УстановленнаяВерсия);
	
	ОбновитьИнформациюДрайвера();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Лев(ТекущийОбъект.ИдентификаторОбъекта, 6) = "AddIn." Тогда
		ТекущийОбъект.ИдентификаторОбъекта = Прав(ТекущийОбъект.ИдентификаторОбъекта, СтрДлина(ТекущийОбъект.ИдентификаторОбъекта) - 6);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбновитьИнформациюДрайвераОборудования()
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайвер_Завершение(РезультатВыполнения, Параметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		ТекстСообщения   = НСтр("ru = 'Установка драйвера оборудования завершена.'");
		ОбновитьИнформациюДрайвераОборудования();
		ПоказатьОповещениеПользователя(НСтр("ru = 'Успешно'"), , ТекстСообщения, БиблиотекаКартинок.ОформлениеЗнакФлажок, 
			СтатусОповещенияПользователя.Важное, ЭтаФорма.УникальныйИдентификатор);
	Иначе
		ТекстСообщения   = РезультатВыполнения.ОписаниеОшибки;
		ПоказатьОповещениеПользователя(НСтр("ru = 'Ошибка'"), , ТекстСообщения, БиблиотекаКартинок.ОформлениеЗнакКрест, 
			СтатусОповещенияПользователя.Важное, ЭтаФорма.УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайвер(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьДрайвер_Завершение",  ЭтотОбъект);
	МенеджерОборудованияКлиент.УстановитьДрайверОборудования(Оповещение, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДрайвер_Завершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Загружена Тогда  
		
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(НСтр("ru = 'Драйвер оборудования обновлен.'"));
		Объект.ВерсияДрайвера = Результат.Версия;
		Записать();
		
		ОбновитьИнформациюДрайвера();
		
	Иначе 
		ПоказатьПредупреждение(, НСтр("ru = 'Ошибка загрузки нового драйвера.'") );
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДрайвер(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Ключ", "Значение");
	
	ПараметрыПоискаТипаКомпонентыПодключения = ВнешниеКомпонентыБПОКлиент.ПараметрыПоискаДополнительнойИнформации();
	ПараметрыПоискаТипаКомпонентыПодключения.ИмяФайлаXML = "INFO.XML";
	ПараметрыПоискаТипаКомпонентыПодключения.ВыражениеXPath = "//drivers/component/@type";
	
	ПараметрыЗагрузки = ВнешниеКомпонентыБПОКлиент.ПараметрыЗагрузки();
	ПараметрыЗагрузки.Идентификатор = Объект.ИдентификаторОбъекта;
	ПараметрыЗагрузки.Версия        = Объект.ВерсияДрайвера;

	ПараметрыЗагрузки.ПараметрыПоискаДополнительнойИнформации.Вставить("ТипКомпонентыПодключения", ПараметрыПоискаТипаКомпонентыПодключения);
	
	Оповещение = Новый ОписаниеОповещения("ОбновитьДрайвер_Завершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ВнешниеКомпонентыБПОКлиент.ЗагрузитьКомпонентуИзФайла(Оповещение, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКФайлуЛогаДрайвера(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ЗапускПриложенияЗавершение", ЭтотОбъект);
	Если МенеджерОборудованияКлиентСервер.СтрокаЗапускаБезопасная(ЛогДрайвераПутьКФайлу) Тогда
		НачатьЗапускПриложения(Оповещение, ЛогДрайвераПутьКФайлу); // АПК:534 произведена проверка запуска
	Иначе
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(
			НСтр("ru = 'Не допускается в пути к файлу использование символов $ ` | || ; & &&'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапускПриложенияЗавершение(КодВозврата, ДополнительныйПараметр) Экспорт
	
	СообщениеОбОшибке = НСтр("ru='Переход к файлу лога драйвера.'");
	ОбщегоНазначенияБПОКлиент.СообщитьПользователю(СообщениеОбОшибке);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранениеЛогаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
#Если Сервер ИЛИ ТонкийКлиент ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение ИЛИ ВнешнееСоединение Тогда
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Попытка                                                 
		ЗаписьZIP = Новый ЗаписьZipФайла(ВыбранныеФайлы[0]);
		ЗаписьZIP.Добавить(ЛогДрайвераПутьКФайлу + "*", РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
		ЗаписьZIP.Записать();
	Исключение
		ВызватьИсключение;
	КонецПопытки;
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьЛогДрайвера(Команда)
	
#Если ТонкийКлиент ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
	// АПК: 1348-выкл не используется модуль ФайловаяСистемаКлиент из БСП
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Каталог = ЛогДрайвераПутьКФайлу;
	Диалог.Расширение = "zip";
	Диалог.Фильтр = НСтр("ru = 'Файл архива'") + " (*.zip)|*.zip";
	ОповещениеВыбораФайла = Новый ОписаниеОповещения("СохранениеЛогаЗавершение", ЭтотОбъект);
	Диалог.Показать(ОповещениеВыбораФайла);
	// АПК: 1348-вкл
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура СохранениеШаблонЛокализации(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
#Если Сервер ИЛИ ТонкийКлиент ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение ИЛИ ВнешнееСоединение Тогда
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Текст = Новый ЗаписьТекста;
		Текст.Открыть(ВыбранныеФайлы[0],КодировкаТекста.UTF8);
		Текст.ЗаписатьСтроку(ШаблонЛокализации);
		Текст.Закрыть();
	Исключение
		ВызватьИсключение;
	КонецПопытки;
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьШаблонЛокализации(Команда)

#Если ТонкийКлиент ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
	// АПК: 1348-выкл не используется модуль ФайловаяСистемаКлиент из БСП
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.МножественныйВыбор = Ложь;
	Диалог.Каталог = ЛогДрайвераПутьКФайлу;
	Диалог.Расширение = "xml";
	Диалог.Фильтр = НСтр("ru = 'Файл локализации драйвера'") + " (*.xml)|*.xml";
	ОповещениеВыбораФайла = Новый ОписаниеОповещения("СохранениеШаблонЛокализации", ЭтотОбъект);
	Диалог.Показать(ОповещениеВыбораФайла);
	// АПК: 1348-вкл
#КонецЕсли

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ОписаниеРевизииИнтерфейса(РевизияИнтерфейса)
	
	СообщениеНаЭкране = НСтр("ru='(Версия требований к разработке драйверов %Версия%)'");
	
	Если РевизияИнтерфейса >= 4000 Тогда
		Результат = Символы.НПП + СообщениеНаЭкране;
		Результат = СтрЗаменить(Результат, "%Версия%", "4." + Строка(РевизияИнтерфейса - 4000));
	ИначеЕсли РевизияИнтерфейса >= 3000 Тогда
		Результат = Символы.НПП + СообщениеНаЭкране;
		Результат = СтрЗаменить(Результат, "%Версия%", "3." + Строка(РевизияИнтерфейса - 3000));
	ИначеЕсли РевизияИнтерфейса >= 2000 Тогда
		Результат = Символы.НПП + СообщениеНаЭкране;
		Результат = СтрЗаменить(Результат, "%Версия%", "2." + Строка(РевизияИнтерфейса - 2000));
	ИначеЕсли РевизияИнтерфейса > 1000 Тогда
		Результат = Символы.НПП + СообщениеНаЭкране;
		Результат = СтрЗаменить(Результат, "%Версия%", "1." + Строка(РевизияИнтерфейса - 1000));
	Иначе
		Результат = "";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьИнформациюДрайвераОборудования_Завершение(РезультатВыполнения, Параметры) Экспорт
	
	Если РезультатВыполнения.Результат Тогда
		
		ОписаниеДрайвера = РезультатВыполнения.ОписаниеДрайвера;
		Если ОписаниеДрайвера.ИнтеграционныйКомпонент Тогда
			ТекущийСтатус = НСтр("ru='Установлен интеграционный компонент.'") + Символы.ПС;
			ТекущийСтатус = ТекущийСтатус + ?(ОписаниеДрайвера.ОсновнойДрайверУстановлен, 
												НСтр("ru='Установлена основная поставка драйвера.'"),
												НСтр("ru='Основная поставка драйвера не установлена.'")); 
		Иначе
			ТекущийСтатус = НСтр("ru='Установлен на текущем компьютере.'");
		КонецЕсли;
		
		Если Не ПустаяСтрока(ОписаниеДрайвера.ВерсияДрайвера) Тогда
			УстановленнаяВерсия = ОписаниеДрайвера.ВерсияДрайвера;
			Если Не ПустаяСтрока(ОписаниеДрайвера.ВерсияИнтеграционногоКомпонента) Тогда
				УстановленнаяВерсия = УстановленнаяВерсия + "/" + ОписаниеДрайвера.ВерсияИнтеграционногоКомпонента;
			КонецЕсли;
			УстановленнаяВерсия = УстановленнаяВерсия + ОписаниеРевизииИнтерфейса(ОписаниеДрайвера.РевизияИнтерфейса);
			Элементы.УстановленнаяВерсия.Видимость = Истина;
		Иначе
			Элементы.УстановленнаяВерсия.Видимость = Ложь;
		КонецЕсли;
		
		Если ОписаниеДрайвера.ЭтоЭмулятор Тогда
			Элементы.ЭтоЭмулятор.Видимость = Истина;    
		КонецЕсли;
		
		Если Не ПустаяСтрока(ОписаниеДрайвера.ЛогДрайвераПутьКФайлу) Тогда
			ЛогДрайвераПутьКФайлу = ОписаниеДрайвера.ЛогДрайвераПутьКФайлу;
			Элементы.ГруппаЛог.Видимость = Истина;
			Элементы.ЛогДрайвераПутьКФайлу.Подсказка = ?(ОписаниеДрайвера.ЛогДрайвераВключен, 
				НСтр("ru='Логирование операций драйвера включено'"), 
				НСтр("ru='Логирование операций драйвера отключено'"));
		#Если ТонкийКлиент ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
			Элементы.СохранитьЛогДрайвера.Видимость = ОписаниеДрайвера.ЛогДрайвераВключен;
			Элементы.ПерейтиКФайлуЛогаДрайвера.Видимость = ОписаниеДрайвера.ЛогДрайвераВключен;
		#Иначе
			Элементы.СохранитьЛогДрайвера.Видимость = Ложь;
			Элементы.ПерейтиКФайлуЛогаДрайвера.Видимость = Ложь;
		#КонецЕсли
		Иначе
			Элементы.ГруппаЛог.Видимость = Ложь;
		КонецЕсли;
		
		ШаблонЛокализации = ОписаниеДрайвера.ШаблонЛокализации;
		#Если ТонкийКлиент ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
			Элементы.ФормаПолучитьШаблонЛокализации.Видимость = Не ПустаяСтрока(ШаблонЛокализации);
		#Иначе
			Элементы.ФормаПолучитьШаблонЛокализации.Видимость = Ложь;  
		#КонецЕсли
			
		Элементы.ФормаУстановитьДрайвер.Видимость = Ложь;        
		
	Иначе      
		ТекущийСтатус = СтрШаблон(НСтр("ru = 'Драйвер не установлен."
		"%1'"), РезультатВыполнения.ОписаниеОшибки);; 
		Элементы.ТекущийСтатус.Подсказка = РезультатВыполнения.ОписаниеОшибки;
		Элементы.ФормаУстановитьДрайвер.Видимость = Не ПодключениеЛокальноПоИдентификатору;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюДрайвераОборудования()
	
	Оповещение = Новый ОписаниеОповещения("ОбновитьИнформациюДрайвераОборудования_Завершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьПолучениеОписанияДрайвера(Оповещение, Неопределено, ДанныеДрайвера);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюДрайвера()
	
	Если ПодключениеИзИнформационнойБазы Тогда
		РезультатИнформация = ВнешниеКомпонентыБПО.ИнформацияОКомпоненте(Объект.ИдентификаторОбъекта, Объект.ВерсияДрайвера);
		Если Не ПустаяСтрока(РезультатИнформация.ОписаниеОшибки) Тогда
			Элементы.ИдентификаторОбъекта.Подсказка = РезультатИнформация.ОписаниеОшибки;
			Элементы.ИдентификаторОбъекта.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
		Иначе
			Элементы.ИдентификаторОбъекта.ОтображениеПодсказки = ОтображениеПодсказки.Всплывающая;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти