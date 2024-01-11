#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция НовыйЗапросЗаполнитьБазуТоваров() Экспорт
	
	Результат = Новый Запрос(
	"ВЫБРАТЬ
	|	Рег.Штрихкод КАК Штрихкод,
	|	ПРЕДСТАВЛЕНИЕ(Рег.Номенклатура) КАК Номенклатура,
	|	ПРЕДСТАВЛЕНИЕ(Рег.Характеристика) КАК Характеристика,
	|	ПРЕДСТАВЛЕНИЕ(Рег.Партия) КАК Партия,
	|	Рег.Номенклатура.АлкогольнаяПродукция КАК Алкоголь,
	|	ВЫБОР
	|		КОГДА Рег.Номенклатура.АлкогольнаяПродукция
	|			ТОГДА Рег.Номенклатура.ВидАлкогольнойПродукции.Маркируемый
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Маркируемый,
	|	ВЫБОР
	|		КОГДА Рег.Номенклатура.АлкогольнаяПродукция
	|			ТОГДА Рег.Номенклатура.ВидАлкогольнойПродукции.Код
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК КодВидаАлкогольнойПродукции,
	|	ВЫБОР
	|		КОГДА Рег.Номенклатура.АлкогольнаяПродукция
	|			ТОГДА Рег.Номенклатура.ОбъемДАЛ * 10
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ЕмкостьТары,
	|	ВЫБОР
	|		КОГДА Рег.Номенклатура.АлкогольнаяПродукция
	|			ТОГДА Рег.Номенклатура.Крепость
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Крепость,
	|	ВЫБОР
	|		КОГДА Рег.Номенклатура.АлкогольнаяПродукция
	|			ТОГДА Рег.Номенклатура.ПроизводительИмпортерАлкогольнойПродукции.ИНН
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ИННПроизводителя,
	|	ВЫБОР
	|		КОГДА Рег.Номенклатура.АлкогольнаяПродукция
	|			ТОГДА Рег.Номенклатура.ПроизводительИмпортерАлкогольнойПродукции.КПП
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК КПППроизводителя
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК Рег
	|
	|УПОРЯДОЧИТЬ ПО
	|	Рег.Штрихкод");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли