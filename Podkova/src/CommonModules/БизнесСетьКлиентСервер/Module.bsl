////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-сеть".
// ОбщийМодуль.БизнесСетьКлиентСервер.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Конвертирует дату из формата UnixTime в тип Дата.
//
// Параметры:
//   Источник - Число - число в формате UnixTime, например 1405955187848899.
//
// Возвращаемое значение:
//   Дата - значение даты.
//
Функция ДатаИзUnixTime(Источник) Экспорт
	
	Возврат МестноеВремя(Дата(1970, 1, 1, 0 ,0, 0) + Источник / 1000)
	
КонецФункции

// Описание идентификации организации контрагентов в сервисе 1С:Бизнес-сеть.
// 
// Возвращаемое значение:
//  Структура - параметры идентификации организации и контрагентов.
//   * Ссылка - СправочникСсылка - ссылка на организацию или контрагента.
//   * ИНН - Строка - ИНН.
//   * КПП - Строка - КПП.
//   * ЭтоОрганизация - Булево - является организацией.
//   * ЭтоКонтрагент - Булево - является контрагентом (по умолчанию).
//
Функция ОписаниеИдентификацииОрганизацииКонтрагентов() Экспорт
	
	Значение = Новый Структура;
	Значение.Вставить("Ссылка", Неопределено);
	Значение.Вставить("ИНН", "");
	Значение.Вставить("КПП", "");
	Значение.Вставить("ЭтоОрганизация", Ложь);
	Значение.Вставить("ЭтоКонтрагент",  Ложь);
	Значение.Вставить("Организация",    Неопределено);
	
	Возврат Значение;
	
КонецФункции

// Добавление текстового блока Подробности см. в журнале регистрации.
//
Функция ПодробностиВЖурналеРегистрации() Экспорт

	Возврат Символы.ПС + НСтр("ru = 'Подробности см. в журнале регистрации.'");

КонецФункции

// Ссылка на промо сайт ЭДО без электронной подписи.
//
// Возвращаемое значение:
//   Строка - Гиперссылка.
//
Функция ГиперссылкаНаПромоСайтЭДО() Экспорт 
	
	Возврат "https://1cbn.ru/edo.html"; 
	
КонецФункции

// Ссылка на промо сайт 1С:Торговая площадка.
//
// Возвращаемое значение:
//   Строка - Гиперссылка.
//
Функция ГиперссылкаНаПромоСайтТорговаяПлощадка() Экспорт
	
	Возврат "https://1cbn.ru/trading.html"; 
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяКомандыПодбораДокументовИзСервиса() Экспорт
	
	Возврат "ПодобратьДокументыИзСервисаБизнесСеть";
	
КонецФункции

Функция ИмяРеквизитаОперацииПодбораДокументовИзСервиса() Экспорт
	
	Возврат "ОбновлениеДанныхДокументовСервисаБизнесСеть";
	
КонецФункции

Функция ИмяРеквизитаВидаДокументаСервиса() Экспорт
	
	Возврат "ВидДокументаСервисаБизнесСеть";
	
КонецФункции

Функция ИмяРеквизитаИспользоватьОбменБизнесСеть() Экспорт
	
	Возврат "ИспользоватьОбменБизнесСеть";
	
КонецФункции

#КонецОбласти