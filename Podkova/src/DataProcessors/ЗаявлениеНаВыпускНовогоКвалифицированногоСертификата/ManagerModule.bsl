///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Возвращает Истина, если в конфигурации используются все перечисленные подсистемы:
// 1. Подсистема Контактная информация  - для работы с российскими адресами.
// 2. Подсистема Адресный классификатор - для получения кода региона по наименованию.
// 3. Подсистема Печать - для печатной формы заявления на выпуск сертификата.
// 4. Подсистема Интернет поддержка пользователей - для подключения к сервисам 1С.
//
// Возвращаемое значение:
//   Булево
//
Функция ЗаявлениеНаВыпускСертификатаДоступно() Экспорт
	
	Возврат ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор")
		И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Печать")
		И ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей");
	
КонецФункции

// Действия при создании формы сертификата на сервере.
// 
// Параметры:
//   Объект           - СправочникОбъект.СертификатыКлючейЭлектроннойПодписиИШифрования - сертификат.
//   ОткрытьЗаявление - Булево - признак того, что вместо формы сертификата необходимо открыть форму
//                    заявления на выпуск нового сертификата.
//
Процедура ПриСозданииНаСервере(Объект, ОткрытьЗаявление) Экспорт
	
	Если ЗначениеЗаполнено(Объект.Ссылка)
		И ЗначениеЗаполнено(Объект.СостояниеЗаявления)
		И Объект.СостояниеЗаявления <> Перечисления.СостоянияЗаявленияНаВыпускСертификата.Исполнено Тогда
		
		ОткрытьЗаявление = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Действия при создании или чтении формы сертификата на сервере.
// 
// Параметры:
//   Объект   - СправочникОбъект.СертификатыКлючейЭлектроннойПодписиИШифрования - сертификат.
//   Элементы - ЭлементыФормы - элементы формы, где:
//     * ФормаПоказатьЗаявлениеПоКоторомуБылПолученСертификат - ПолеФормы
//     * ПоказатьЗаявлениеПоКоторомуБылПолученСертификат - ПолеФормы
//
Процедура ПриСозданииНаСервереПриЧтенииНаСервере(Объект, Элементы) Экспорт
	
	Если ЗначениеЗаполнено(Объект.СостояниеЗаявления) Тогда
		Если Объект.СостояниеЗаявления = Перечисления.СостоянияЗаявленияНаВыпускСертификата.Исполнено Тогда
			
			Элементы.ФормаПоказатьЗаявлениеПоКоторомуБылПолученСертификат.Доступность = Истина;
			Элементы.ПоказатьЗаявлениеПоКоторомуБылПолученСертификат.Доступность = Истина;
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//  ЭлементУсловногоОформления - ЭлементУсловногоОформленияКомпоновкиДанных
//
Процедура УстановитьУсловноеОформлениеСпискаСертификатов(ЭлементУсловногоОформления) Экспорт
	
	СписокСостояний = Новый СписокЗначений;
	СписокСостояний.Добавить(Перечисления.СостоянияЗаявленияНаВыпускСертификата.ПустаяСсылка());
	СписокСостояний.Добавить(Перечисления.СостоянияЗаявленияНаВыпускСертификата.Исполнено);
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СостояниеЗаявления");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбораДанных.ПравоеЗначение = СписокСостояний;
	ЭлементОтбораДанных.Использование  = Истина;
	
КонецПроцедуры

Процедура ДополнитьЗапросПриДобавленииСертификатов(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"ЛОЖЬ КАК ЭтоЗаявление",
		"ВЫБОР
		|		КОГДА Сертификаты.СостояниеЗаявления = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаявленияНаВыпускСертификата.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		КОГДА Сертификаты.СостояниеЗаявления = ЗНАЧЕНИЕ(Перечисление.СостоянияЗаявленияНаВыпускСертификата.Исполнено)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЭтоЗаявление");

КонецПроцедуры

Процедура ДополнитьЗапросСпискаСертификатов(ТекстЗапроса) Экспорт
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ДополнительноеУсловие",
		"СертификатыПереопределяемый.СостояниеЗаявления В (
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияЗаявленияНаВыпускСертификата.ПустаяСсылка),
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияЗаявленияНаВыпускСертификата.Исполнено) )");
	
КонецПроцедуры

// Параметры:
//  НеРедактируемыеРеквизиты - Массив
//
Процедура РеквизитыНеРедактируемыеВГрупповойОбработке(НеРедактируемыеРеквизиты) Экспорт
	
	НеРедактируемыеРеквизиты.Добавить("СостояниеЗаявления");
	НеРедактируемыеРеквизиты.Добавить("СодержаниеЗаявления");
	
КонецПроцедуры

// Параметры:
//  Гражданство - СправочникСсылка.СтраныМира
//
Функция ГражданствоСвойства(Гражданство) Экспорт
	
	Значения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Гражданство,
		"Наименование, НаименованиеПолное, КодАльфа3");
	
	Свойства = Новый Структура;
	Свойства.Вставить("ГражданствоОКСМКодАльфа3", Строка(Значения.КодАльфа3));
	Если ЗначениеЗаполнено(Значения.НаименованиеПолное) Тогда
		Свойства.Вставить("ГражданствоПредставление", Строка(Значения.НаименованиеПолное));
	Иначе
		Свойства.Вставить("ГражданствоПредставление", Строка(Значения.Наименование));
	КонецЕсли;
	
	Возврат Свойства;
	
КонецФункции

Функция ПроверитьАдрес(Адрес, ЭтоФЛ) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат "";
	КонецЕсли;
	
	Сообщение = "";
	МодульРаботаСАдресами = ОбщегоНазначения.ОбщийМодуль("РаботаСАдресами");
	
	Попытка
		
		ПодробныйИтог = МодульРаботаСАдресами.ПроверитьАдрес(Адрес);
		Если ПодробныйИтог.Результат <> "Корректный" Тогда
			
			Для каждого ЭлементСписка Из ПодробныйИтог.СписокОшибок Цикл
				Сообщение = Сообщение + Символы.ПС + ЭлементСписка.Представление;
			КонецЦикла;
			
			Сообщение = СокрЛП(Сообщение);
			Если Не ЗначениеЗаполнено(Сообщение) Тогда
				Сообщение = НСтр("ru = 'Адрес не заполнен'");
			КонецЕсли;
			Если ЭтоФЛ Тогда
				Сообщение = Сообщение + " (" + НСтр("ru = 'не ошибка, если указан регион и населенный пункт'")+ ")";
			Иначе
				Сообщение = Сообщение + " (" + НСтр("ru = 'не ошибка, если так в ЕГРЮЛ'")+ ")";
			КонецЕсли;
		КонецЕсли;
		
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Сообщение = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
	КонецПопытки;
	
	Возврат Сообщение;
	
КонецФункции

Функция РеквизитыОрганизации(Форма) Экспорт
	
	Реквизиты = Новый СписокЗначений;
	Реквизиты.Добавить("ЭтоИндивидуальныйПредприниматель", НСтр("ru = 'Вид'"), Истина);
	Реквизиты.Добавить("ЭтоФизическоеЛицо",                НСтр("ru = 'Физическое лицо'"), Истина);
	Реквизиты.Добавить("НаименованиеСокращенное",          НСтр("ru = 'Наименование (сокращенное)'"));
	Реквизиты.Добавить("НаименованиеПолное",               НСтр("ru = 'Наименование (полное)'"));
	Реквизиты.Добавить("ИНН",                              НСтр("ru = 'ИНН'"));
	Реквизиты.Добавить("КПП",                              НСтр("ru = 'КПП'"));
	Реквизиты.Добавить("ОГРН",                             НСтр("ru = 'ОГРН'"));
	Реквизиты.Добавить("РасчетныйСчет",                    НСтр("ru = 'Расчетный счет'"), Истина);
	Реквизиты.Добавить("БИК",                              НСтр("ru = 'БИК'"), Истина);
	Реквизиты.Добавить("КорреспондентскийСчет",            НСтр("ru = 'Корреспондентский счет'"), Истина);
	Реквизиты.Добавить("ЮридическийАдрес",                 НСтр("ru = 'Адрес регистрации'"));
	Реквизиты.Добавить("Телефон",                          НСтр("ru = 'Телефон'"));
	
	Если Форма <> Неопределено И Форма.ЭтоИндивидуальныйПредприниматель Тогда
		Реквизиты.НайтиПоЗначению("КПП").Пометка = Истина;
	КонецЕсли;
	
	Возврат Реквизиты;
	
КонецФункции

Функция РеквизитыВладельцаСертификата(Форма, ЭтоИП = Неопределено, ЭтоФЛ = Неопределено) Экспорт
	
	Реквизиты = Новый СписокЗначений;
	Реквизиты.Добавить("Фамилия",                  НСтр("ru = 'Фамилия'"));
	Реквизиты.Добавить("Имя",                      НСтр("ru = 'Имя'"));
	Реквизиты.Добавить("Отчество",                 НСтр("ru = 'Отчество'"), Истина);
	Реквизиты.Добавить("ДатаРождения",             НСтр("ru = 'Дата рождения'"));
	Реквизиты.Добавить("Пол",                      НСтр("ru = 'Пол'"));
	Реквизиты.Добавить("СтраховойНомерПФР",        НСтр("ru = 'СНИЛС'"));
	Реквизиты.Добавить("ВладелецИНН",              НСтр("ru = 'ИНН'"));
	Реквизиты.Добавить("Гражданство",              НСтр("ru = 'Гражданство'"));
	Реквизиты.Добавить("МестоРождения",            НСтр("ru = 'Место рождения'"));
	Реквизиты.Добавить("Должность",                НСтр("ru = 'Должность'"));
	Реквизиты.Добавить("Подразделение",            НСтр("ru = 'Подразделение'"), Истина);
	Реквизиты.Добавить("ДокументВид",              НСтр("ru = 'Вид документа'"));
	Реквизиты.Добавить("ДокументНомер",            НСтр("ru = 'Серия и номер'"));
	Реквизиты.Добавить("ДокументКемВыдан",         НСтр("ru = 'Кем выдан'"));
	Реквизиты.Добавить("ДокументДатаВыдачи",       НСтр("ru = 'Дата выдачи'"));
	Реквизиты.Добавить("ДокументКодПодразделения", НСтр("ru = 'Код подразделения'"));
	Реквизиты.Добавить("ВладелецАдресРегистрации", НСтр("ru = 'Адрес регистрации'"));
	Реквизиты.Добавить("ЭлектроннаяПочта",         НСтр("ru = 'Электронная почта'"));
	Реквизиты.Добавить("ВладелецТелефон",          НСтр("ru = 'Телефон'"));
	
	Если Форма <> Неопределено Тогда
		Если ЭтоИП =  Неопределено И (Форма.ЭтоИндивидуальныйПредприниматель Или Форма.ЭтоФизическоеЛицо)
		 Или ЭтоИП <> Неопределено И (ЭтоИП Или ЭтоФЛ) Тогда
			Реквизиты.НайтиПоЗначению("Должность").Пометка = Истина;
		КонецЕсли;
		Если ЭтоФЛ =  Неопределено И Не Форма.ЭтоФизическоеЛицо
		 Или ЭтоФЛ <> Неопределено И Не ЭтоФЛ Тогда
			Реквизиты.НайтиПоЗначению("ВладелецИНН").Пометка = Истина;
			Реквизиты.НайтиПоЗначению("ВладелецАдресРегистрации").Пометка = Истина;
			Реквизиты.НайтиПоЗначению("ВладелецТелефон").Пометка = Истина;
		КонецЕсли;
		Если Форма.ДокументВид <> "21" Тогда
			Реквизиты.НайтиПоЗначению("ДокументНомер").Пометка = Истина;
			Реквизиты.НайтиПоЗначению("ДокументКодПодразделения").Пометка = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Реквизиты;
	
КонецФункции

// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//  ПроверяемыеРеквизиты - Массив
//  РеквизитыДляПроверки - СписокЗначений
//  ПолеСообщения - Строка
//  ШаблонСообщения - Строка
//
Процедура ДобавитьРеквизитыДляПроверки(Форма, ПроверяемыеРеквизиты, РеквизитыДляПроверки,
			ПолеСообщения = "", ШаблонСообщения = "%1:") Экспорт
	
	Для Каждого Реквизит Из РеквизитыДляПроверки Цикл
		
		ИмяРеквизита = Реквизит.Значение;
		
		ПараметрыРеквизитаДляПроверки = Новый Структура;
		ПараметрыРеквизитаДляПроверки.Вставить("Имя", ИмяРеквизита);
		Если ИмяРеквизита = "Телефон"
			Или ИмяРеквизита = "ЮридическийАдрес"
			Или ИмяРеквизита = "ВладелецАдресРегистрации"
			Или ИмяРеквизита = "ВладелецТелефон" Тогда
			ПараметрыРеквизитаДляПроверки.Вставить("Значение", Форма[ИмяРеквизита + "XML"]);
		Иначе
			ПараметрыРеквизитаДляПроверки.Вставить("Значение", Форма[ИмяРеквизита]);
		КонецЕсли;
		ПараметрыРеквизитаДляПроверки.Вставить("ПолеСообщения",
			?(ЗначениеЗаполнено(ПолеСообщения), ПолеСообщения, ИмяРеквизита));
		
		Если Реквизит.Пометка Тогда
			ТекстНезаполненного = "";
		Иначе
			ТекстНезаполненного = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонСообщения, Реквизит.Представление);
		КонецЕсли;
		ПараметрыРеквизитаДляПроверки.Вставить("ТекстНезаполненного", ТекстНезаполненного);
		ПараметрыРеквизитаДляПроверки.Вставить("ТекстПроверкиЗначения",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Реквизит.Представление));
		
		ПроверяемыеРеквизиты.Добавить(ПараметрыРеквизитаДляПроверки);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПроверитьЗаполнениеРеквизитов(Форма, Реквизиты, ЭтоИП, ЭтоФЛ, ПроверкаИзОбщейФормы = Истина) Экспорт
	
	Отказ = Ложь;
	ВидДокумента = "";
	РасчетныйСчет = Неопределено;
	
	Для Каждого Реквизит Из Реквизиты Цикл
		
		Если Реквизит.Имя = "БИК" Тогда
			БИК = Реквизит.Значение;
		ИначеЕсли Реквизит.Имя = "КорреспондентскийСчет" Тогда
			КорреспондентскийСчет = Реквизит.Значение;
		ИначеЕсли Реквизит.Имя = "РасчетныйСчет" Тогда
			РасчетныйСчет = Реквизит;
		ИначеЕсли Реквизит.Имя = "ДокументВид" Тогда
			ВидДокумента = Реквизит.Значение;
		ИначеЕсли Реквизит.Имя = "ДокументНомер" Тогда
			НомерДокумента = Реквизит;
		ИначеЕсли Реквизит.Имя = "ДокументКодПодразделения" Тогда
			КодПодразделения = Реквизит;
		КонецЕсли;
		
		ПроверитьЗаполнениеРеквизита(Форма, Реквизит, Отказ, ЭтоИП, ЭтоФЛ, ПроверкаИзОбщейФормы);
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(РасчетныйСчет) И ЗначениеЗаполнено(РасчетныйСчет.Значение) Тогда
		
		ТекстОшибки = ОшибкиПроверкиКонтрольногоЧислаРасчетногоСчета(РасчетныйСчет.Значение, БИК, КорреспондентскийСчет);
		Если Не ПустаяСтрока(ТекстОшибки) Тогда
			ТекстОшибки = РасчетныйСчет.ТекстПроверкиЗначения + " " + ТекстОшибки;
			СообщитьПользователю(Форма, ТекстОшибки, РасчетныйСчет.ПолеСообщения, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если ВидДокумента = "21" Тогда
		
		ТекстОшибки = ОшибкиПроверкиКодаПодразделения(КодПодразделения.Значение);
		Если Не ПустаяСтрока(ТекстОшибки) Тогда
			ТекстОшибки = КодПодразделения.ТекстПроверкиЗначения + " " + ТекстОшибки;
			СообщитьПользователю(Форма, ТекстОшибки, КодПодразделения.ПолеСообщения, Отказ);
		КонецЕсли;
		
		ТекстОшибки = ОшибкиПроверкиНомераПаспорта(НомерДокумента.Значение);
		Если Не ПустаяСтрока(ТекстОшибки) Тогда
			ТекстОшибки = НомерДокумента.ТекстПроверкиЗначения + " " + ТекстОшибки;
			СообщитьПользователю(Форма, ТекстОшибки, НомерДокумента.ПолеСообщения, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции

Процедура ПроверитьЗаполнениеРеквизита(Форма, Реквизит, Отказ, ЭтоИП, ЭтоФЛ, ПроверкаИзОбщейФормы)
	
	ИмяРеквизита = Реквизит.Имя;
	ПолеСообщения = Реквизит.ПолеСообщения;
	ЗначениеРеквизита = Реквизит.Значение;
	
	Если Не ЗначениеЗаполнено(ЗначениеРеквизита) Тогда
		
		Если ЗначениеЗаполнено(Реквизит.ТекстНезаполненного) Тогда
			ТекстОшибки = Реквизит.ТекстНезаполненного + " " + ТекстОшибкиПолеНеЗаполнено();
			СообщитьПользователю(Форма, ТекстОшибки, ПолеСообщения, Отказ);
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	ТекстСообщения = "";
	ПродолжитьПриОшибке = Ложь;
	
	Если ИмяРеквизита = "ИНН"
	 Или ИмяРеквизита = "ВладелецИНН"
	 Или ИмяРеквизита = "ДокументыПартнерИНН" Тогда
		
		РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(ЗначениеРеквизита,
			Не (ЭтоИП Или ЭтоФЛ), ТекстСообщения);
		
	ИначеЕсли ИмяРеквизита = "ДокументыПартнерКПП"
	      Или ИмяРеквизита = "КПП" Тогда
		
		РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(ЗначениеРеквизита, ТекстСообщения);
		
	ИначеЕсли ИмяРеквизита = "ОГРН" Тогда
		РегламентированныеДанныеКлиентСервер.ОГРНСоответствуетТребованиям(ЗначениеРеквизита, Не ЭтоИП, ТекстСообщения);
		
	ИначеЕсли ИмяРеквизита = "РасчетныйСчет" Тогда
		ТекстСообщения = ОшибкиПроверкиРасчетногоСчета(ЗначениеРеквизита);
		
	ИначеЕсли ИмяРеквизита = "БИК" Тогда
		ТекстСообщения = ОшибкиПроверкиБИК(ЗначениеРеквизита);
		
	ИначеЕсли ИмяРеквизита = "КорреспондентскийСчет" Тогда
		ТекстСообщения = ОшибкиПроверкиКорреспондентскогоСчета(ЗначениеРеквизита);
		
	ИначеЕсли ИмяРеквизита = "ЮридическийАдрес"
	      Или ИмяРеквизита = "ВладелецАдресРегистрации" Тогда
		
		ТекстСообщения = ОшибкиПроверкиАдреса(ЗначениеРеквизита);
		Если ПустаяСтрока(ТекстСообщения) Тогда
			ПродолжитьПриОшибке = ПроверкаИзОбщейФормы;
			ТекстСообщения = ПроверитьАдрес(ЗначениеРеквизита, ЭтоФЛ);
		КонецЕсли;
		
	ИначеЕсли ИмяРеквизита = "Телефон"
	      Или ИмяРеквизита = "ВладелецТелефон" Тогда
		
		ТекстСообщения = ОшибкиПроверкиТелефона(ЗначениеРеквизита);
		
	ИначеЕсли ИмяРеквизита = "СтраховойНомерПФР" Тогда
		РегламентированныеДанныеКлиентСервер.СтраховойНомерПФРСоответствуетТребованиям(
			ЗначениеРеквизита, ТекстСообщения);
		
	ИначеЕсли ИмяРеквизита = "ЭлектроннаяПочта" Тогда
		
		Попытка
			ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ЗначениеРеквизита);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекстСообщения) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстыОшибок = СтрРазделить(ТекстСообщения, Символы.ПС + Символы.ВК, Ложь);
	Для Каждого ТекстОшибки Из ТекстыОшибок Цикл
		ТекстОшибки = Реквизит.ТекстПроверкиЗначения + " " + ТекстОшибки;
		СообщитьПользователю(Форма, ТекстОшибки, ПолеСообщения,
			?(ПродолжитьПриОшибке, Неопределено, Отказ));
	КонецЦикла;
	
КонецПроцедуры

Функция ТекстОшибкиПолеНеЗаполнено() Экспорт
	Возврат НСтр("ru = 'Поле не заполнено'");
КонецФункции

Функция ОшибкиПроверкиРасчетногоСчета(РасчетныйСчет)
	
	Значение = СокрЛП(РасчетныйСчет);
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Значение) Тогда
		Возврат НСтр("ru = 'Расчетный счет должен состоять только из цифр.'");
	КонецЕсли;
	
	Если СтрДлина(Значение) <> 20 Тогда
		Возврат НСтр("ru = 'Расчетный счет должен состоять из 20 цифр.'");
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ОшибкиПроверкиКонтрольногоЧислаРасчетногоСчета(РасчетныйСчет, БИК, КорреспондентскийСчет)
	
	ЭтоБанк = ЗначениеЗаполнено(КорреспондентскийСчет);
	Если Не РегламентированныеДанныеКлиентСервер.КонтрольныйКлючЛицевогоСчетаСоответствуетТребованиям(РасчетныйСчет, БИК, ЭтоБанк) Тогда
		Возврат НСтр("ru = 'Контрольное число счета не совпадает с рассчитанным с учетом БИК'");
	КонецЕсли;
	
КонецФункции

Функция ОшибкиПроверкиБИК(БИК)
	
	Значение = СокрЛП(БИК);
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Значение) Тогда
		Возврат НСтр("ru = 'БИК должен состоять только из цифр.'");
	КонецЕсли;
	
	Если СтрДлина(Значение) <> 9 Тогда
		Возврат НСтр("ru = 'БИК должен состоять из 9 цифр.'");
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ОшибкиПроверкиКорреспондентскогоСчета(КорреспондентскийСчет)
	
	Значение = СокрЛП(КорреспондентскийСчет);
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Значение) Тогда
		Возврат НСтр("ru = 'Корреспондентский счет должен состоять только из цифр.'");
	КонецЕсли;

	Если СтрДлина(Значение) <> 20 Тогда
		Возврат НСтр("ru = 'Корреспондентский счет должен состоять из 20 цифр.'");
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ОшибкиПроверкиАдреса(Знач АдресXML)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат "";
	КонецЕсли;
	
	МодульРаботаСАдресами = ОбщегоНазначения.ОбщийМодуль("РаботаСАдресами");
	
	ТекстСообщения = "";
	ДополнительныеПараметры = Новый Структура("НаименованиеВключаетСокращение", Истина);
	АдресСтруктура = МодульРаботаСАдресами.СведенияОбАдресе(АдресXML, ДополнительныеПараметры);
	
	// Проверка, что адрес российский.
	Если Не АдресСтруктура.Свойство("КодРегиона") Тогда
		Возврат ТекстСообщения + НСтр("ru = 'Это не российский адрес'");
	КонецЕсли;
	
	// Проверка, что указан регион.
	Если Не АдресСтруктура.Свойство("Регион") Или Не ЗначениеЗаполнено(АдресСтруктура.Регион) Тогда
		Возврат ТекстСообщения + НСтр("ru = 'Не указан регион'");
	КонецЕсли;
	
	// Проверка, что регион указан правильно - код региона определен.
	Если Не ЗначениеЗаполнено(АдресСтруктура.КодРегиона) Тогда
		Возврат ТекстСообщения + НСтр("ru = 'Некорректный регион (код региона не определен)'");
	КонецЕсли;
	
	// Населенный пункт полностью.
	НаселенныйПунктПолностью = НаселенныйПунктПолностью(АдресСтруктура);
	Если Не ЗначениеЗаполнено(НаселенныйПунктПолностью) Тогда
		Возврат ТекстСообщения + НСтр("ru = 'Не указан населенный пункт'");
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ОшибкиПроверкиТелефона(Знач ТелефонXML)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат "";
	КонецЕсли;
	
	МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
	
	ТекстСообщения = "";
	ТелефонСтруктура = МодульУправлениеКонтактнойИнформацией.СведенияОТелефоне(ТелефонXML);
	
	// Проверка, что телефон российский.
	Если СтрЗаменить(ТелефонСтруктура.КодСтраны, "+", "") <> "7" Тогда
		Возврат ТекстСообщения + НСтр("ru = 'Код страны не российский (должен быть ""7"")'");
	КонецЕсли;
	
	НомерТелефонаБезКодаСтраны = ТелефонСтруктура.КодГорода + ТелефонСтруктура.НомерТелефона;
	
	Если Не ЗначениеЗаполнено(НомерТелефонаБезКодаСтраны) Тогда
		Возврат ТекстСообщения + НСтр("ru = 'Не заполнен номер телефона'");
	КонецЕсли;
	
	Если СтрДлина(ТолькоЦифры(НомерТелефонаБезКодаСтраны)) <> 10 Тогда
		Возврат ТекстСообщения + НСтр("ru = 'Номер телефона с кодом города должен состоять из 10-и цифр'");
	КонецЕсли;
	
	Если СтрДлина(ТелефонСтруктура.Добавочный) > 6 Тогда
		Возврат НСтр("ru = 'Добавочный номер телефона не может быть длиннее 6 символов.'");
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ТелефонДляОтправкиВСервис(ТелефонXML) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат "";
	КонецЕсли;
	
	МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
	ТелефонСтруктура = МодульУправлениеКонтактнойИнформацией.СведенияОТелефоне(ТелефонXML);
	
	ТелефонДляСервиса = "+" + СтрЗаменить(ТелефонСтруктура.КодСтраны, "+", "")
		+ "(" + ТолькоЦифры(ТелефонСтруктура.КодГорода) + ")" + ТолькоЦифры(ТелефонСтруктура.НомерТелефона);
		
	Если ЗначениеЗаполнено(ТелефонСтруктура.Добавочный) Тогда
		ТелефонДляСервиса = ТелефонДляСервиса + ", д." + ТелефонСтруктура.Добавочный;
	КонецЕсли;
	
	// Не более 24 символа.
	Возврат ТелефонДляСервиса;
	
КонецФункции

Функция ОшибкиПроверкиКодаПодразделения(КодПодразделения)
	
	Если ПустаяСтрока(КодПодразделения) Тогда
		Возврат "";
	КонецЕсли;
	
	СтрокаЦифр = СокрЛП(КодПодразделения);
	Если СтрДлина(СтрокаЦифр) < 6 Тогда
		Возврат НСтр("ru = 'Код подразделения задан неполностью'");
	КонецЕсли;
	
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаЦифр) Тогда
		Возврат НСтр("ru = 'Код подразделения должен состоять только из цифр.'");
	КонецЕсли;
	
	Если СтрокаЦифр = "000000" Тогда
		Возврат НСтр("ru = 'Код подразделения не может быть нулевым.'");
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ОшибкиПроверкиНомераПаспорта(Знач НомерПаспортаРФ)
	
	Если ПустаяСтрока(НомерПаспортаРФ) Тогда
		Возврат "";
	КонецЕсли;
	
	СтрокаЦифр = СтрЗаменить(НомерПаспортаРФ, ",", "");
	СтрокаЦифр = СтрЗаменить(СтрокаЦифр, " ", "");
	
	Если ПустаяСтрока(СтрокаЦифр) Тогда
		Возврат НСтр("ru = 'Номер паспорта не заполнен'");
	КонецЕсли;
	
	Если СтрДлина(СтрокаЦифр) < 10 Тогда
		Возврат НСтр("ru = 'Номер паспорта задан неполностью'");
	КонецЕсли;
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаЦифр) Тогда
		Возврат НСтр("ru = 'Номер паспорта должен состоять только из цифр.'");
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Функция ТолькоЦифры(Строка)
	
	ДлинаСтроки = СтрДлина(Строка);
	
	ОбработаннаяСтрока = "";
	Для НомерСимвола = 1 По ДлинаСтроки Цикл
		
		Символ = Сред(Строка, НомерСимвола, 1);
		Если Символ >= "0" И Символ <= "9" Тогда
			ОбработаннаяСтрока = ОбработаннаяСтрока + Символ;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ОбработаннаяСтрока;
	
КонецФункции

Функция НаселенныйПунктПолностью(АдресСтруктура)
	
	// Округ ОкругСокращение, Район РайонСокращение, Город ГородСокращение,
	// ВнутригородскойРайон ВнутригородскойРайонСокращение, НаселенныйПункт НаселенныйПунктСокращение.
	СписокПолей = "";
	
	Если АдресСтруктура.Свойство("Регион")
	   И АдресСтруктура.Свойство("КодРегиона")
	   И (    АдресСтруктура.КодРегиона = "77"
	      Или АдресСтруктура.КодРегиона = "78"
	      Или АдресСтруктура.КодРегиона = "92"
	      Или АдресСтруктура.КодРегиона = "99") Тогда
		
		СписокПолей = "Регион, КодРегиона, ";
	КонецЕсли;
	
	Возврат ПредставлениеЧастиАдреса(АдресСтруктура, СписокПолей +
		"Округ,
		|Район,
		|Город,
		|ВнутригородскойРайон,
		|НаселенныйПункт,
		|Территория");
	
КонецФункции

Функция ПредставлениеЧастиАдреса(АдресСтруктура, СписокПолей)
	
	Представление = "";
	СтруктураПолей = Новый Структура(СписокПолей);
	ЗаполнитьЗначенияСвойств(СтруктураПолей, АдресСтруктура);
	
	МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
	Представление = МодульУправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(СтруктураПолей);
	
	Возврат Представление;
	
КонецФункции

Процедура СообщитьПользователю(Форма, ТекстСообщения, Поле, Отказ = Ложь) Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.ИдентификаторНазначения = Форма.УникальныйИдентификатор;
	Сообщение.Текст = ТекстСообщения;
	Сообщение.Поле = Поле;
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли