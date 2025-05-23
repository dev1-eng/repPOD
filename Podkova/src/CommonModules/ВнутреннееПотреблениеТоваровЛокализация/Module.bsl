
#Область ПрограммныйИнтерфейс

// Добавляет в текст запроса реквизиты табличной части "Товары".
//  Реквизиты добавляются вместо параметра "&ВнутреннееПотреблениеТоваров_ТоварыЛокализация".
//
// Параметры:
//  ТекстЗапроса - Строка				 - Исходный текст запроса.
//  ИмяТаблицы	 - Строка, Неопределено	 - Синоним таблицы документа в запросе.
//  	Для получения пустых значений нужно передать "Неопределено".
//
Процедура ДобавитьВТекстЗапросаРеквизитыТаблицыТовары(ТекстЗапроса, ИмяТаблицы) Экспорт

	ПоляЛокализация = "NULL";
	
	//++ Локализация
	
	Если ИмяТаблицы = Неопределено Тогда
		ПоляЛокализация = 
		"	ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)             КАК ФизическоеЛицо,
		|	ЗНАЧЕНИЕ(Справочник.КатегорииЭксплуатации.ПустаяСсылка)      КАК КатегорияЭксплуатации,
		|	ЗНАЧЕНИЕ(Справочник.ПартииТМЦВЭксплуатации.ПустаяСсылка)     КАК ПартияТМЦВЭксплуатации,
		|	""""                                                         КАК ИнвентарныйНомер";
	Иначе
		ПоляЛокализация = 
		"	Таблица.ФизическоеЛицо          КАК ФизическоеЛицо,
		|	Таблица.КатегорияЭксплуатации   КАК КатегорияЭксплуатации,
		|	Таблица.ПартияТМЦВЭксплуатации  КАК ПартияТМЦВЭксплуатации,
		|	Таблица.ИнвентарныйНомер        КАК ИнвентарныйНомер";
	КонецЕсли; 
	
	ПоляЛокализация = СтрЗаменить(ПоляЛокализация, "Таблица", ИмяТаблицы);
	
	//-- Локализация

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВнутреннееПотреблениеТоваров_ТоварыЛокализация", ПоляЛокализация);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
	//++ Локализация
	
	Движения = Объект.Движения;
	ДополнительныеСвойства = Объект.ДополнительныеСвойства;
	
	
	ПроведениеСерверУТ.ОтразитьДвижения(
		ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаТМЦВЭксплуатации,
		Движения.ТМЦВЭксплуатации,
		Отказ);
	
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	//++ Локализация
	
	
	//-- Локализация
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	//++ Локализация
	
	
	Справочники.ПартииТМЦВЭксплуатации.ЗаполнитьПартии(Объект, Отказ);
	
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект.<Имя документа> - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	//++ Локализация
	
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		СтрокаТЧ.ПартияТМЦВЭксплуатации = Справочники.ПартииТМЦВЭксплуатации.ПустаяСсылка();
	КонецЦикла;
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
КонецПроцедуры

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт


КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	//++ Локализация
	Отчеты.МатериалыВЭксплуатации.ДобавитьКомандуОтчета(КомандыОтчетов);
	//-- Локализация
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	//++ Локализация
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранение") Тогда
		// МХ-3 
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
		КомандаПечати.Идентификатор = "МХ3";
		КомандаПечати.Представление = НСтр("ru = 'Акт о возврате ТМЦ, сданных на хранение (МХ-3)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КонецЕсли;
	
	
	// Требование-накладная (М-11)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьМ11";
	КомандаПечати.Идентификатор = "М11";
	КомандаПечати.Представление = НСтр("ru = 'Требование-накладная (М-11)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	//-- Локализация
КонецПроцедуры

// Добавляет команду создания документа "Внутреннее потребление товаров".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОснованииПередачаВЭксплуатацию(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.ВнутреннееПотреблениеТоваров) 
		И ПолучитьФункциональнуюОпцию("ИспользоватьВнутреннееПотребление") Тогда
		
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Обработчик = "СозданиеНаОснованииУТКлиент.ПередачаВЭксплуатациюНаОсновании";
		КомандаСоздатьНаОсновании.Идентификатор = "ПередачаВЭксплуатациюНаОсновании";
		КомандаСоздатьНаОсновании.Представление = НСтр("ru = 'Передача в эксплуатацию'");
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "НеБазоваяВерсия";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;

КонецФункции

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	//++ Локализация
	//-- Локализация
КонецПроцедуры

//++ Локализация

// Функция получает данные для формирования печатной формы МХ - 3
//
Функция ПолучитьДанныеДляПечатнойФормыМХ3(ПараметрыПечати, МассивОбъектов) Экспорт
	
	КолонкаКодов = ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
	Если Не ЗначениеЗаполнено(КолонкаКодов) Тогда
		КолонкаКодов = "Код";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	РасчетСебестоимостиТоваровОрганизации.Ссылка.ПредварительныйРасчет КАК ПредварительныйРасчет,
	|	Документ.Ссылка КАК Ссылка,
	|	Документ.Номер КАК Номер,
	|	Документ.Дата КАК Дата,
	|	Документ.Дата КАК ДатаДокумента,
	|	Документ.Организация КАК Организация,
	|	Документ.Склад КАК Склад,
	|	Склады.ИсточникИнформацииОЦенахДляПечати КАК ИсточникИнформацииОЦенахДляПечати,
	|	Склады.УчетныйВидЦены КАК ВидЦены,
	|	Склады.УчетныйВидЦены.ВалютаЦены КАК ВалютаЦены
	|ПОМЕСТИТЬ ВтШапка
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров КАК Документ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасчетСебестоимостиТоваров.Организации КАК РасчетСебестоимостиТоваровОрганизации
	|		ПО (РасчетСебестоимостиТоваровОрганизации.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(Документ.Ссылка.Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(Документ.Ссылка.Дата, МЕСЯЦ))
	|			И (РасчетСебестоимостиТоваровОрганизации.Ссылка.Проведен)
	|			И (Документ.Ссылка.Организация = РасчетСебестоимостиТоваровОрганизации.Организация)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|		ПО (Документ.Склад = Склады.Ссылка)
	|ГДЕ
	|	Документ.Ссылка В(&МассивДокументов)
	|	И Документ.Проведен
	|	И Склады.СкладОтветственногоХранения
	|	И Документ.Организация <> Склады.Поклажедержатель
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Шапка.Склад КАК Склад,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения КАК ЕдиницаИзмеренияНаименование,
	|	&ТекстЗапросаКодЕдиницыИзмерения КАК ЕдиницаИзмеренияКод,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения КАК ВидУпаковки,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Количество КАК Количество,
	|	КОНЕЦПЕРИОДА(Товары.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	Шапка.ВидЦены КАК ВидЦены,
	|	Шапка.ВалютаЦены КАК ВалютаЦены
	|ПОМЕСТИТЬ ВтТовары
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров.Товары КАК Товары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	|		ПО Товары.Ссылка = Шапка.Ссылка
	|ГДЕ
	|	Товары.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И (Шапка.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоВидуЦен)
	|		ИЛИ (Шапка.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	|			И Шапка.ПредварительныйРасчет ЕСТЬ NULL))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыЗапасов.Ссылка КАК Ссылка,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ВидыЗапасов.ВидЗапасов КАК ВидЗапасов,
	|	Шапка.Организация КАК Организация,
	|	АналитикаУчетаНоменклатуры.СкладскаяТерритория КАК Склад,
	|	АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК Упаковка,
	|	ВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
	|	АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
	|	АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,
	|	АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Представление ВидУпаковки,
	|	ВидыЗапасов.Количество КАК КоличествоУпаковок,
	|	ВидыЗапасов.Количество КАК Количество,
	|	КОНЕЦПЕРИОДА(ВидыЗапасов.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	АналитикаУчетаНоменклатуры.СкладскаяТерритория.УчетныйВидЦены КАК ВидЦены,
	|	АналитикаУчетаНоменклатуры.СкладскаяТерритория.УчетныйВидЦены.ВалютаЦены КАК ВалютаЦены,
	|	Шапка.ПредварительныйРасчет КАК ПредварительныйРасчет
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров.ВидыЗапасов КАК ВидыЗапасов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	|		ПО ВидыЗапасов.Ссылка = Шапка.Ссылка
	|ГДЕ
	|	АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И АналитикаУчетаНоменклатуры.СкладскаяТерритория.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	|;
	|";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаНаименованиеЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование", "Товары.Упаковка", "Товары.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКодЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код", "Товары.Упаковка", "Товары.Номенклатура"));
	
	СкладыСервер.ДополнитьТекстЗапросаДляПечатныхФормМХ1Х3(Запрос);
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("КолонкаКодов", КолонкаКодов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	РезультатПоШапке = МассивРезультатов[6];
	РезультатПоСкладам = МассивРезультатов[7];
	РезультатПоТабличнойЧасти = МассивРезультатов[8];
	
	СтруктураДанныхДляПечати = Новый Структура(
		"РезультатПоШапке, РезультатПоСкладам, РезультатПоТабличнойЧасти",
		РезультатПоШапке,
		РезультатПоСкладам,
		РезультатПоТабличнойЧасти);
		
	Возврат СтруктураДанныхДляПечати
	
КонецФункции

// Функция получает данные для формирования печатной формы М-11
//
Функция ПолучитьДанныеДляПечатнойФормыМ11(ПараметрыПечати, МассивДокументов) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	КОНЕЦПЕРИОДА(Товары.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	Товары.Ссылка.ВидЦены КАК ВидЦены,
	|	Товары.Ссылка.ВидЦены.ВалютаЦены КАК ВалютаЦены
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка В(&МассивДокументов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПериодыЦенНоменклатуры.Ссылка,
	|	ПериодыЦенНоменклатуры.НомерСтроки,
	|	ЦеныНоменклатуры.Цена,
	|	ЦеныНоменклатуры.Упаковка
	|ПОМЕСТИТЬ Цены
	|ИЗ
	|	(ВЫБРАТЬ
	|		Товары.Ссылка КАК Ссылка,
	|		Товары.НомерСтроки КАК НомерСтроки,
	|		ЦеныНоменклатуры.ВидЦены КАК ВидЦены,
	|		ЦеныНоменклатуры.Номенклатура КАК Номенклатура,
	|		ЦеныНоменклатуры.Характеристика КАК Характеристика,
	|		МАКСИМУМ(ЦеныНоменклатуры.Период) КАК Период
	|	ИЗ
	|		Товары КАК Товары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|			ПО Товары.ВидЦены = ЦеныНоменклатуры.ВидЦены
	|				И Товары.Номенклатура = ЦеныНоменклатуры.Номенклатура
	|				И Товары.Характеристика = ЦеныНоменклатуры.Характеристика
	|				И Товары.ДатаПолученияЦены >= ЦеныНоменклатуры.Период
	|				И Товары.ВалютаЦены = ЦеныНоменклатуры.Валюта
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Товары.Ссылка,
	|		Товары.НомерСтроки,
	|		ЦеныНоменклатуры.ВидЦены,
	|		ЦеныНоменклатуры.Номенклатура,
	|		ЦеныНоменклатуры.Характеристика) КАК ПериодыЦенНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|		ПО ПериодыЦенНоменклатуры.Период = ЦеныНоменклатуры.Период
	|			И ПериодыЦенНоменклатуры.ВидЦены = ЦеныНоменклатуры.ВидЦены
	|			И ПериодыЦенНоменклатуры.Номенклатура = ЦеныНоменклатуры.Номенклатура
	|			И ПериодыЦенНоменклатуры.Характеристика = ЦеныНоменклатуры.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПериодыКурсовВалютПоДокументам.Ссылка,
	|	КурсыВалют.Валюта,
	|	КурсыВалют.Курс,
	|	КурсыВалют.Кратность
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	(ВЫБРАТЬ
	|		Документы.Ссылка КАК Ссылка,
	|		МАКСИМУМ(КурсыВалют.Период) КАК Период,
	|		КурсыВалют.Валюта КАК Валюта
	|	ИЗ
	|		Документ.ВнутреннееПотреблениеТоваров КАК Документы
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
	|			ПО Документы.ВидЦены.ВалютаЦены = КурсыВалют.Валюта
	|				И Документы.Дата >= КурсыВалют.Период
	|	ГДЕ
	|		Документы.Ссылка В(&МассивДокументов)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Документы.Ссылка,
	|		КурсыВалют.Валюта) КАК ПериодыКурсовВалютПоДокументам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
	|		ПО ПериодыКурсовВалютПоДокументам.Период = КурсыВалют.Период
	|			И ПериодыКурсовВалютПоДокументам.Валюта = КурсыВалют.Валюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Документы.Ссылка КАК Ссылка,
	|	Документы.Номер КАК Номер,
	|	Документы.Дата КАК ДатаДокумента,
	|	Документы.Дата КАК ДатаСоставления,
	|	Документы.Организация КАК Организация,
	|	Документы.Организация.Префикс КАК Префикс,
	|	Документы.Подразделение КАК Подразделение,
	|	Документы.ВидЦены КАК УчетныйВидЦены,
	|	Документы.ВидЦены.ВалютаЦены КАК УчетныйВидЦеныВалютаЦены
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров КАК Документы
	|ГДЕ
	|	Документы.Ссылка В(&МассивДокументов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДокумента,
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.Ссылка.Склад КАК Склад,
	|	ВЫРАЗИТЬ(Товары.Ссылка.Склад КАК Справочник.Склады).ТекущийОтветственный КАК КладовщикОтправитель,
	|	ВЫРАЗИТЬ(Товары.Ссылка.Склад КАК Справочник.Склады).ТекущаяДолжностьОтветственного КАК ДолжностьКладовщикаОтправителя,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Номенклатура.НаименованиеПолное КАК НоменклатураНаименование,
	|	Товары.Номенклатура.Код КАК НоменклатурныйНомерКод,
	|	Товары.Номенклатура.Артикул КАК НоменклатурныйНомерАртикул,
	|	Товары.Характеристика.НаименованиеПолное КАК Характеристика,
	|	ВЫБОР КОГДА ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) = 1
	|		ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ Товары.Упаковка.Наименование
	|	КОНЕЦ КАК Упаковка,
	|	&ТекстЗапросаНаименованиеЕдиницыИзмерения КАК ЕдиницаИзмеренияНаименование,
	|	&ТекстЗапросаКодЕдиницыИзмерения КАК ЕдиницаИзмеренияКод,
	|	Товары.КоличествоУпаковок КАК Количество,
	|	(ВЫРАЗИТЬ(ЕСТЬNULL(Цены.Цена, 0) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) * ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) * ЕСТЬNULL(КурсыВалют.Курс, 1) / ЕСТЬNULL(КурсыВалют.Кратность, 1) КАК ЧИСЛО(31,2))) * Товары.КоличествоУпаковок КАК Сумма,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Цены.Цена, 0) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) * ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) * ЕСТЬNULL(КурсыВалют.Курс, 1) / ЕСТЬNULL(КурсыВалют.Кратность, 1) КАК ЧИСЛО(31,2)) КАК Цена,
	|	Товары.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсыВалют
	|		ПО Товары.Ссылка = КурсыВалют.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Цены КАК Цены
	|		ПО Товары.Ссылка = Цены.Ссылка
	|			И Товары.НомерСтроки = Цены.НомерСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ
	|	МАКСИМУМ(ДолжностьКладовщикаОтправителя), МАКСИМУМ(КладовщикОтправитель)
	|ПО
	|	Ссылка,
	|	Склад");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"Товары.Упаковка",
			"Товары.Номенклатура"));
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"Цены.Упаковка",
			"Товары.Номенклатура"));
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаНаименованиеЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование",
			"Товары.Упаковка",
			"Товары.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКодЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код",
			"Товары.Упаковка",
			"Товары.Номенклатура"));
		
	Запрос.УстановитьПараметр("МассивДокументов", МассивДокументов);
	
	РезультатПакетаЗапросов = Запрос.ВыполнитьПакет();
	// Пакет запросов:
	// 		[0] - Временная таблица по табличной части документа
	// 		[1] - Временная таблица по ценам номенклатуры табличной части
	// 		[2] - Временная таблица по курсам валют документов
	// 		[3] - Выборка по шапкам документов
	// 		[4] - Выборка по табличным частям документов.
	
	Возврат Новый Структура(
		"РезультатПоШапке, РезультатПоТабличнойЧасти",
		РезультатПакетаЗапросов[3],
		РезультатПакетаЗапросов[4]);
	
КонецФункции

//-- Локализация
#КонецОбласти

#Область Проведение

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра, СинонимТаблицыДокумента, ВЗапросеЕстьИсточник, ПереопределениеРасчетаПараметров) Экспорт

	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапроса = Неопределено;
	
	//++ Локализация

	
	//-- Локализация
	
	Возврат ТекстЗапроса; 
	
КонецФункции

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация

		
	ТекстЗапросаТаблицаТМЦВЭксплуатации(Запрос, ТекстыЗапроса, Регистры);
	
	//-- Локализация
	
КонецПроцедуры

Процедура ДополнитьТекстЗапросаТаблицаТоварыОрганизаций(ТекстЗапроса) Экспорт

	ХозяйственнаяОперация_Локализация = "&ХозяйственнаяОперация";
	
	//++ Локализация
	
	ХозяйственнаяОперация_Локализация =
	"ВЫБОР
	|		
	|		КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаВЭксплуатацию)
	|		ТОГДА
	|			ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеТоваровПоТребованию)
	|	ИНАЧЕ &ХозяйственнаяОперация
	|КОНЕЦ";
	
	//-- Локализация
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ХозяйственнаяОперация_Локализация", ХозяйственнаяОперация_Локализация);
	
КонецПроцедуры

Процедура ДополнитьТекстЗапросаТаблицаСебестоимостьТоваров(ТекстЗапроса) Экспорт

	ХозяйственнаяОперация_Условие1 = "ЛОЖЬ";
	ХозяйственнаяОперация_Значение1 = "НЕОПРЕДЕЛЕНО";
	ХозяйственнаяОперация_Условие2 = "ЛОЖЬ";
	ХозяйственнаяОперация_Значение2 = "НЕОПРЕДЕЛЕНО";
	
	//++ Локализация
	
	
	ХозяйственнаяОперация_Условие2 = 
		"&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаВЭксплуатацию)
		|";
	ХозяйственнаяОперация_Значение2 = "ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СписаниеТоваровПоТребованию)";
	
	//-- Локализация
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ХозяйственнаяОперация_Условие1", ХозяйственнаяОперация_Условие1);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ХозяйственнаяОперация_Значение1", ХозяйственнаяОперация_Значение1);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ХозяйственнаяОперация_Условие2", ХозяйственнаяОперация_Условие2);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ХозяйственнаяОперация_Значение2", ХозяйственнаяОперация_Значение2);
	
КонецПроцедуры

Процедура ДополнитьЗначенияПараметровПроведения(ЗначенияПараметровПроведения, Реквизиты) Экспорт
	//++ Локализация
	//-- Локализация
КонецПроцедуры

#КонецОбласти


#Область ФормаДокумента

// Вызывается из соответствующего обработчика документа
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт

	//++ Локализация
	
	Элементы = Форма.Элементы;

	Если ПолучитьФункциональнуюОпцию("ИспользоватьТМЦВЭксплуатации") Тогда
		Элементы.ХозяйственнаяОперация.СписокВыбора.Добавить(Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию);
		Элементы.ХозяйственнаяОперация.Видимость = Истина;
	КонецЕсли; 
	
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
Процедура ПриЧтенииСозданииНаСервере(Форма) Экспорт

	//++ Локализация
	
	НастроитьПанельНавигации(Форма);
	
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи) Экспорт

	//++ Локализация
	//-- Локализация
	
КонецПроцедуры
 
// Вызывается при изменении реквизита ХозяйственнаяОперация в документе
//
Процедура ХозяйственнаяОперацияПриИзменении(Форма, ИзмененныеРеквизиты, ДополнительныеПараметры) Экспорт

	//++ Локализация
	
	Объект = Форма.Объект;
	
	Если НЕ ПустаяСтрока(ИзмененныеРеквизиты) Тогда
		МассивРеквизитов = СтрРазделить(ИзмененныеРеквизиты, ",");
	Иначе
		МассивРеквизитов = Новый Массив;
	КонецЕсли; 
	
	Если ДополнительныеПараметры.ОчиститьТовары Тогда
		Объект.Товары.Очистить();
		Объект.ЗаказНаВнутреннееПотребление = Неопределено;
		МассивРеквизитов.Добавить("Товары");
		МассивРеквизитов.Добавить("ЗаказНаВнутреннееПотребление");
	КонецЕсли;
	
	НастроитьПанельНавигации(Форма);
	
	ИзмененныеРеквизиты = СтрСоединить(МассивРеквизитов, ",");
	
	//-- Локализация
	
КонецПроцедуры

// Вызывается из процедуры НастроитьЗависимыеЭлементыФормыНаСервере формы документа
//
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СтруктураИзмененныхРеквизитов) Экспорт

	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

// Вызывается из процедуры ЗаполнитьПоЗаказуСервер формы документа
//
Процедура ОбработатьДокументПослеДобавленияСтрок(Объект) Экспорт

	//++ Локализация
	РазбитьСтрокиОбъектовЭксплуатацииСИнвентарнымУчетом(Объект);
	//-- Локализация
	
КонецПроцедуры

Процедура УстановитьУсловноеОформление(Форма) Экспорт

	//++ Локализация
	
	УсловноеОформление = Форма.УсловноеОформление;
	Элементы = Форма.Элементы;
	
	
	//-- Локализация
	
КонецПроцедуры

Процедура ЗаполнитьСлужебныеРеквизитыТабличнойЧасти(Объект) Экспорт

	//++ Локализация
	
	
	//-- Локализация
	
КонецПроцедуры
 
#КонецОбласти

#Область Прочее

Процедура ПараметрыЗаполненияВидаДеятельностиНДС(Объект, ПараметрыЗаполнения) Экспорт
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию Тогда
		ПараметрыЗаполнения.ПередачаВЭксплуатацию = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(Знач ХозяйственнаяОперация, ВсеРеквизиты, РеквизитыОперации) Экспорт
	
	//++ Локализация
	
	ВсеРеквизиты.Добавить("Товары.ФизическоеЛицо");
	ВсеРеквизиты.Добавить("Товары.КатегорияЭксплуатации");
	ВсеРеквизиты.Добавить("Товары.ИнвентарныйНомер");
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию Тогда
		РеквизитыОперации.Добавить("Товары.СтатьяРасходов");
		РеквизитыОперации.Добавить("Товары.АналитикаРасходов");
		РеквизитыОперации.Добавить("Товары.ФизическоеЛицо");
		РеквизитыОперации.Добавить("Товары.КатегорияЭксплуатации");
		РеквизитыОперации.Добавить("Подразделение");
	КонецЕсли;

	//-- Локализация

КонецПроцедуры

Процедура УстановитьУсловноеОформлениеСписка(Список) Экспорт

	//++ Локализация
	
	// Передача в эксплуатацию
	
	Элемент = Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Тип");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ХозяйственнаяОперация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тип");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Передача в эксплуатацию'"));
	
	//-- Локализация
	
КонецПроцедуры

Процедура ХозяйственныеОперацииДокумента(СписокОпераций) Экспорт

	//++ Локализация
	СписокОпераций.Добавить(Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию);
	//-- Локализация
		
КонецПроцедуры
 
#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ Локализация

#Область Печать


#КонецОбласти

#Область Проведение

Функция ТекстЗапросаТаблицаТМЦВЭксплуатации(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ТМЦВЭксплуатации";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Таблица.НомерСтроки КАК НомерСтроки,
	|	
	|	&Ссылка КАК Регистратор,
	|	&Период КАК Период,
	|	
	|	&Организация КАК Организация,
	|	&Подразделение КАК Подразделение,
	|	Таблица.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.ПартияТМЦВЭксплуатации КАК Партия,
	|	
	|	Таблица.Количество КАК Количество
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров.Товары КАК Таблица
	|	
	|ГДЕ
	|	Таблица.Ссылка = &Ссылка
	|	И &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПередачаВЭксплуатацию)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции


#КонецОбласти

#Область ОбработчикиСобытий


#КонецОбласти

#Область ФормаДокумента

Процедура НастроитьПанельНавигации(Форма)
	
	Объект = Форма.Объект;
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИспользоватьМатериалыВЭксплуатации",
		Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию
		ИЛИ Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации);
	
	ОбщегоНазначенияУТ.НастроитьФормуПоПараметрам(Форма, СтруктураНастроек);
	
КонецПроцедуры

// Разбивает строки табличной части товары, если для объекта эксплуатации требуется инвентарный учет.
//
//  Параметры:
//   Объект - ДокументСсылка.ВнутреннееПотреблениеТоваров, ДанныеФормыСтруктураСКоллекцией - документ, для разбиения строк.
//
Процедура РазбитьСтрокиОбъектовЭксплуатацииСИнвентарнымУчетом(Объект)
	
	Таблица = Объект.Товары;
	
	// Получение категорий эксплуатации документа.
	МассивКатегорий = Новый Массив();
	
	
	Если МассивКатегорий.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Получение категорий эксплуатации с ведением инвентарного учета.
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивКатегорий", МассивКатегорий);
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СпрКатегорииЭксплуатации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.КатегорииЭксплуатации КАК СпрКатегорииЭксплуатации
		|ГДЕ
		|	СпрКатегорииЭксплуатации.ИнвентарныйУчет
		|	И СпрКатегорииЭксплуатации.Ссылка В(&МассивКатегорий)";
	
	КатегорииСИнвентарнымУчетом = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	// Разбиение строк для категорий эксплуатации с ведением инвентарного учета.
	Если КатегорииСИнвентарнымУчетом.Количество() > 0 Тогда
		
		ВсегоСтрок = Таблица.Количество();
		// Обход таблицы, поиск строк.
		Для Счетчик = 1 По ВсегоСтрок Цикл
			
			СтрокаТаблицы = Таблица[ВсегоСтрок - Счетчик];
			Если КатегорииСИнвентарнымУчетом.Найти(СтрокаТаблицы.КатегорияЭксплуатации) <> Неопределено Тогда
				
				// Разбиение строк.
				КоличествоВСтроке = СтрокаТаблицы.Количество - 1;
				СтрокаТаблицы.КоличествоУпаковок = 1;
				СтрокаТаблицы.Количество = 1;
				СтрокаТаблицы.Упаковка = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
				
				Пока КоличествоВСтроке > 0 Цикл
					НоваяСтрока = Таблица.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
					КоличествоВСтроке = КоличествоВСтроке - 1;
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее


#КонецОбласти

//-- Локализация

#КонецОбласти
