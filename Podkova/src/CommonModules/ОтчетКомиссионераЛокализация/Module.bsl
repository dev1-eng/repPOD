
#Область ПрограммныйИнтерфейс

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
	
	Движения = Объект.Движения;
	ДополнительныеСвойства = Объект.ДополнительныеСвойства;
	//++ Локализация
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
	
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	//++ Локализация
	
	ЭтоПартнер = ПраваПользователяПовтИсп.ЭтоПартнер();
	
	// Счет-фактура
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
	КомандаПечати.Идентификатор = "СчетФактура";
	КомандаПечати.Представление = НСтр("ru = 'Счет-фактура'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = НЕ ЭтоПартнер;
	КомандаПечати.ДополнительныеПараметры.Вставить("ПечатьВВалюте", Ложь);

	Если НЕ ЭтоПартнер Тогда
		
		// Счет-фактура (в валюте)
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
		КомандаПечати.Идентификатор = "СчетФактураВВалюте";
		КомандаПечати.Представление = НСтр("ru = 'Счет-фактура (в валюте)'");
		КомандаПечати.ФункциональныеОпции = "ИспользоватьНесколькоВалют";
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.ДополнительныеПараметры.Вставить("ПечатьВВалюте", Истина);
		
		// Универсальный передаточный документ (УПД)
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
		КомандаПечати.Идентификатор = "УПД";
		КомандаПечати.Представление = НСтр("ru = 'Универсальный передаточный документ (УПД)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
				
	КонецЕсли;
	//-- Локализация
	
КонецПроцедуры

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

// Формирует текст запроса для получения данных основания при печати Счет-фактуры.
//
Функция ТекстЗапросаДанныхОснованияДляПечатнойФормыСчетФактура() Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка                                   КАК Ссылка,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПустаяСсылка) КАК ХозяйственнаяОперация,
	|	ДанныеДокументов.Валюта                                   КАК Валюта,
	|	ДанныеДокументов.Организация                              КАК Организация,
	|	ДанныеДокументов.НалогообложениеНДС                       КАК НалогообложениеНДС,
	|	ДанныеДокументов.Подразделение                            КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)                  КАК Склад,
	|	ДанныеДокументов.Грузоотправитель                         КАК Грузоотправитель,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)             КАК Грузополучатель,
	|	ЛОЖЬ                                                      КАК РасчетыЧерезОтдельногоКонтрагента,
	|	НЕОПРЕДЕЛЕНО                                              КАК Номенклатура,
	|	""""                                                      КАК Содержание,
	|	ДанныеДокументов.Организация                              КАК Комиссионер,
	|	НЕОПРЕДЕЛЕНО                                              КАК Основание,
	|	НЕОПРЕДЕЛЕНО                            				  КАК ОснованиеДата,
	|	НЕОПРЕДЕЛЕНО                           					  КАК ОснованиеНомер,
	|	НЕОПРЕДЕЛЕНО                                              КАК БанковскийСчетОрганизации,
	|	НЕОПРЕДЕЛЕНО                                              КАК БанковскийСчетКонтрагента,
	|	НЕОПРЕДЕЛЕНО                                              КАК БанковскийСчетГрузоотправителя,
	|	НЕОПРЕДЕЛЕНО                                              КАК БанковскийСчетГрузополучателя,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДоверенностьНомер,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДоверенностьДата,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДоверенностьВыдана,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДоверенностьЛицо,
	|	НЕОПРЕДЕЛЕНО                                              КАК Кладовщик,
	|	НЕОПРЕДЕЛЕНО                                              КАК ДолжностьКладовщика
	|
	|//ОператорПОМЕСТИТЬ
	|ИЗ
	|	Документ.ОтчетКомиссионера КАК ДанныеДокументов
	|ГДЕ
	|	ДанныеДокументов.Ссылка В (&ДокументОснование_ОтчетКомиссионера)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПолучитьДанныеДляПечатнойФормыУПД(ПараметрыПечати, МассивОбъектов) Экспорт
	
	КолонкаКодов = ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
	Если Не ЗначениеЗаполнено(КолонкаКодов) Тогда
		КолонкаКодов = "Код";
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка                  КАК Ссылка,
	|	ДанныеДокументов.Валюта                  КАК Валюта,
	|	ДанныеДокументов.Организация             КАК Организация,
	|	ДанныеДокументов.Подразделение           КАК Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка) КАК Склад
	|
	|ПОМЕСТИТЬ ТаблицаДанныхДокументов
	|ИЗ
	|	Документ.ОтчетКомиссионера КАК ДанныеДокументов
	|
	|ГДЕ
	|	ДанныеДокументов.Ссылка В (&МассивОбъектов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	УчетНДСРФ.ДополнитьЗапросПолученияДанныхДляПечатиУПД(Запрос);

	Запрос.Выполнить();
	
	ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц);
	ПродажиСервер.ПоместитьВременнуюТаблицуДанныхПоставщика(МенеджерВременныхТаблиц);
	ОтветственныеЛицаСервер.СформироватьВременнуюТаблицуОтветственныхЛицДокументов(МассивОбъектов, МенеджерВременныхТаблиц);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	&ПредставлениеСчетФактура КАК ПредставлениеДокумента,
	|	2 КАК СтатусУПД,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.Дата КАК Дата,
	|	НЕОПРЕДЕЛЕНО КАК НомерИсправления,
	|	НЕОПРЕДЕЛЕНО КАК ДатаИсправления,
	|	ЛОЖЬ КАК Исправление,
	|	НЕОПРЕДЕЛЕНО КАК НомерСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК ДатаСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК НомерИсправленияСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК ДатаИсправленияСчетаФактуры,
	|	ЛОЖЬ КАК КорректировочныйСчетФактура,
	|	"""" КАК СтрокаПоДокументу,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаСчетаФактуры,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ВЫБОР
	|		КОГДА ТаблицаТоваров.Покупатель.ОбособленноеПодразделение
	|			ТОГДА ТаблицаТоваров.Покупатель.ГоловнойКонтрагент
	|		ИНАЧЕ ТаблицаТоваров.Покупатель
	|	КОНЕЦ КАК Контрагент,
	|	ДанныеДокумента.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ДанныеПоставщика.ГоловнаяОрганизация КАК Организация,
	|	ДанныеДокумента.Организация.Префикс КАК Префикс,
	|	0 КАК ИндексПодразделения,
	|	ТаблицаОтветственныеЛица.РуководительНаименование КАК Руководитель,
	|	ТаблицаОтветственныеЛица.РуководительДолжность КАК ДолжностьРуководителя,
	|	ТаблицаОтветственныеЛица.ГлавныйБухгалтерНаименование КАК ГлавныйБухгалтер,
	|	ТаблицаТоваров.Покупатель КАК Грузополучатель,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.Грузоотправитель = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|			ТОГДА ДанныеДокумента.Организация
	|		ИНАЧЕ ДанныеДокумента.Грузоотправитель
	|	КОНЕЦ КАК Грузоотправитель,
	|	ДанныеПоставщика.КПППоставщика КАК КПППоставщика,
	|	""""                           КАК КПППокупателя,
	|	ТаблицаТоваров.Покупатель.ИНН  КАК ИННПокупателя,
	|	НЕОПРЕДЕЛЕНО КАК АдресДоставки,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Валюта.НаименованиеПолное КАК ВалютаНаименованиеПолное,
	|	ДанныеДокумента.Валюта.Код КАК ВалютаКод,
	|	ЛОЖЬ КАК ТолькоУслуги,
	|	ЛОЖЬ КАК ЭтоПередачаНаКомиссию,
	|	НЕОПРЕДЕЛЕНО КАК Основание,
	|	НЕОПРЕДЕЛЕНО КАК ДоверенностьНомер,
	|	НЕОПРЕДЕЛЕНО КАК ДоверенностьДата,
	|	НЕОПРЕДЕЛЕНО КАК ДоверенностьВыдана,
	|	НЕОПРЕДЕЛЕНО КАК ДоверенностьЛицо,
	|	НЕОПРЕДЕЛЕНО КАК Кладовщик,
	|	НЕОПРЕДЕЛЕНО КАК ДолжностьКладовщика,
	|	ТаблицаТоваров.Покупатель КАК Покупатель,
	|	ДанныеДокументов.ТребуетсяНаличиеСФ КАК ТребуетсяНаличиеСФ
	|ИЗ
	|	Документ.ОтчетКомиссионера КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ДанныеДокументов
	|		ПО ДанныеДокумента.Ссылка = ДанныеДокументов.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
	|			ТаблицаТоваров.Ссылка КАК Ссылка,
	|			ТаблицаТоваров.Покупатель КАК Покупатель
	|		ИЗ
	|			ОтчетКомиссионераТаблицаТоваров КАК ТаблицаТоваров) КАК ТаблицаТоваров
	|		ПО ДанныеДокумента.Ссылка = ТаблицаТоваров.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДанныеПоставщика КАК ДанныеПоставщика
	|		ПО ДанныеДокумента.Ссылка = ДанныеПоставщика.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаОтветственныеЛица КАК ТаблицаОтветственныеЛица
	|		ПО ДанныеДокумента.Ссылка = ТаблицаОтветственныеЛица.Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ТаблицаДокумента.Номенклатура.НаименованиеПолное КАК НоменклатураНаименование,
	|	ВЫБОР
	|		КОГДА &КолонкаКодов = ""Артикул""
	|			ТОГДА ТаблицаДокумента.Номенклатура.Артикул
	|		ИНАЧЕ ТаблицаДокумента.Номенклатура.Код
	|	КОНЕЦ КАК НоменклатураКод,
	|	ВЫБОР
	|		КОГДА &ВыводитьБазовыеЕдиницыИзмерения
	|			ТОГДА ТаблицаДокумента.Номенклатура.ЕдиницаИзмерения
	|		ИНАЧЕ &ТекстЗапросаЕдиницаИзмерения
	|	КОНЕЦ КАК ЕдиницаИзмерения,
	|	ВЫБОР
	|		КОГДА &ВыводитьБазовыеЕдиницыИзмерения
	|			ТОГДА ТаблицаДокумента.Номенклатура.ЕдиницаИзмерения.Представление
	|		ИНАЧЕ &ТекстЗапросаНаименованиеЕдиницыИзмерения
	|	КОНЕЦ КАК ЕдиницаИзмеренияНаименование,
	|	ВЫБОР
	|		КОГДА &ВыводитьБазовыеЕдиницыИзмерения
	|			ТОГДА ТаблицаДокумента.Номенклатура.ЕдиницаИзмерения.Код
	|		ИНАЧЕ &ТекстЗапросаКодЕдиницыИзмерения
	|	КОНЕЦ КАК ЕдиницаИзмеренияКод,
	|	ТаблицаДокумента.Характеристика КАК Характеристика,
	|	ТаблицаДокумента.Характеристика.НаименованиеПолное КАК ХарактеристикаНаименование,
	|	ТаблицаДокумента.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаДокумента.НомерГТД КАК НомерГТД,
	|	ТаблицаДокумента.НомерГТД.СтранаПроисхождения КАК СтранаПроисхождения,
	|	ТаблицаДокумента.НомерГТД.СтранаПроисхождения.Код КАК СтранаПроисхожденияКод,
	|	ВЫБОР
	|		КОГДА &ВыводитьБазовыеЕдиницыИзмерения
	|			ТОГДА ТаблицаДокумента.Количество
	|		ИНАЧЕ ТаблицаДокумента.КоличествоУпаковок
	|	КОНЕЦ КАК Количество,
	|	ВЫБОР
	|		КОГДА &ВыводитьБазовыеЕдиницыИзмерения
	|			ТОГДА ТаблицаДокумента.СуммаБезНДС / ТаблицаДокумента.Количество
	|		ИНАЧЕ ТаблицаДокумента.СуммаБезНДС / ТаблицаДокумента.КоличествоУпаковок
	|	КОНЕЦ КАК Цена,
	|	ТаблицаДокумента.СуммаБезНДС КАК СуммаБезНДС,
	|	ТаблицаДокумента.СуммаНДС КАК СуммаНДС,
	|	ТаблицаДокумента.СуммаБезНДС + ТаблицаДокумента.СуммаНДС КАК СуммаСНДС,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара,
	|	ТаблицаДокумента.ДатаСчетаФактурыКомиссионера КАК Дата,
	|	ТаблицаДокумента.Покупатель КАК Покупатель
	|ИЗ
	|	ОтчетКомиссионераТаблицаТоваров КАК ТаблицаДокумента
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка";
	
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&ТекстЗапросаЕдиницаИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Ссылка",
			"ТаблицаДокумента.Упаковка",
			"ТаблицаДокумента.Номенклатура"));
			
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&ТекстЗапросаНаименованиеЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Наименование",
			"ТаблицаДокумента.Упаковка",
			"ТаблицаДокумента.Номенклатура"));
	
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст,
		"&ТекстЗапросаКодЕдиницыИзмерения",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаЗначениеРеквизитаЕдиницыИзмерения(
			"Код",
			"ТаблицаДокумента.Упаковка",
			"ТаблицаДокумента.Номенклатура"));
	
	Запрос.УстановитьПараметр("ВыводитьБазовыеЕдиницыИзмерения", Константы.ВыводитьБазовыеЕдиницыИзмерения.Получить());
	Запрос.УстановитьПараметр("ПредставлениеСчетФактура", НСтр("ru='счет-фактура'"));
	Запрос.УстановитьПараметр("КолонкаКодов", КолонкаКодов);
	
	МассивРезультатов         = Запрос.ВыполнитьПакет();
	РезультатПоШапке          = МассивРезультатов[0];
	РезультатПоТабличнойЧасти = МассивРезультатов[1];
	
	СтруктураДанныхДляПечати 	= Новый Структура;
	СтруктураДанныхДляПечати.Вставить("РезультатПоШапке", РезультатПоШапке);
	СтруктураДанныхДляПечати.Вставить("РезультатПоТабличнойЧасти", РезультатПоТабличнойЧасти);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

// Формирует временную таблицу, содержащую табличную часть по таблице данных документов.
//
// Параметры:
//	МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - Менеджер временных таблиц, содержащий таблицу ТаблицаДанныхДокументов с полями:
//		Ссылка.
//
//	ПараметрыЗаполнения - Структура - структура, возвращаемая функцией ПродажиСервер.ПараметрыЗаполненияВременнойТаблицыТоваров.
//
Процедура ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц, ПараметрыЗаполнения = Неопределено) Экспорт
	
	Если ПараметрыЗаполнения = Неопределено Тогда
		ПараметрыЗаполнения = ПродажиСервер.ПараметрыЗаполненияВременнойТаблицыТоваров();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ПересчитыватьВВалютуРегл", ПараметрыЗаполнения.ПересчитыватьВВалютуРегл);
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ТаблицаТоваров.Ссылка КАК Ссылка,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Упаковка КАК Упаковка,
	|	МАКСИМУМ(ТаблицаТоваров.НомерСтроки) КАК НомерСтроки
	|
	|ПОМЕСТИТЬ СтрокиТоваров
	|ИЗ
	|	Документ.ОтчетКомиссионера.Товары КАК ТаблицаТоваров
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокументов КАК ДанныеДокументов
	|	ПО
	|		ТаблицаТоваров.Ссылка = ДанныеДокументов.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаТоваров.Ссылка,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Упаковка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТаблицаТоваров.Ссылка,
	|	ТаблицаТоваров.АналитикаУчетаНоменклатуры,
	|	ТаблицаТоваров.Упаковка
	|;
	|/////////////////////////////////////////////////////////////////////////////
	| // выборка товаров
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	СтрокиТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	ТаблицаДокумента.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	ТаблицаДокумента.АналитикаУчетаНоменклатуры.Серия КАК Серия,
	|	ТаблицаДокумента.НомерГТД КАК НомерГТД,
	|	СУММА(ТаблицаДокумента.Количество) КАК Количество,
	|	СУММА(ТаблицаДокумента.КоличествоУпаковок) КАК КоличествоУпаковок,
	|	
	|	СУММА(ЕСТЬNULL(
	|		СуммыДокументовВВалютеРегл.СуммаБезНДСРегл,
	|		ТаблицаДокумента.СуммаСНДС - ТаблицаДокумента.СуммаНДС
	|	)) КАК СуммаБезНДС,
	|	
	|	ТаблицаДокумента.СтавкаНДС КАК СтавкаНДС,
	|	
	|	СУММА(ЕСТЬNULL(
	|		СуммыДокументовВВалютеРегл.СуммаНДСРегл,
	|		ТаблицаДокумента.СуммаНДС
	|	)) КАК СуммаНДС,
	|	
	|	ИСТИНА КАК ЭтоТовар,
	|	ЛОЖЬ КАК ВернутьМногооборотнуюТару,
	|	ТаблицаДокумента.Упаковка КАК Упаковка,
	|	ТаблицаДокумента.ДатаСчетаФактурыКомиссионера КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаДокумента.Покупатель КАК Покупатель,
	|	ТаблицаДокумента.НомерСчетаФактурыКомиссионера КАК НомерСчетаФактурыКомиссионера
	|
	|ПОМЕСТИТЬ ОтчетКомиссионераТаблицаТоваров
	|ИЗ
	|	Документ.ОтчетКомиссионера.ВидыЗапасов КАК ТаблицаДокумента
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокументов КАК ДанныеДокументов
	|	ПО
	|		ТаблицаДокумента.Ссылка = ДанныеДокументов.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютеРегл КАК СуммыДокументовВВалютеРегл
	|	ПО
	|		ТаблицаДокумента.Ссылка = СуммыДокументовВВалютеРегл.Регистратор
	|		И ТаблицаДокумента.ИдентификаторСтроки = СуммыДокументовВВалютеРегл.ИдентификаторСтроки
	|		И СуммыДокументовВВалютеРегл.Активность
	|		И &ПересчитыватьВВалютуРегл
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		СтрокиТоваров КАК СтрокиТоваров
	|	ПО
	|		ТаблицаДокумента.Ссылка = СтрокиТоваров.Ссылка
	|		И ТаблицаДокумента.АналитикаУчетаНоменклатуры = СтрокиТоваров.АналитикаУчетаНоменклатуры
	|		И ТаблицаДокумента.Упаковка = СтрокиТоваров.Упаковка
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Ссылка,
	|	СтрокиТоваров.НомерСтроки,
	|	ТаблицаДокумента.АналитикаУчетаНоменклатуры.Номенклатура,
	|	ТаблицаДокумента.АналитикаУчетаНоменклатуры.Характеристика,
	|	ТаблицаДокумента.АналитикаУчетаНоменклатуры.Серия,
	|	ТаблицаДокумента.СтавкаНДС,
	|	ТаблицаДокумента.Упаковка,
	|	ТаблицаДокумента.НомерГТД,
	|	ТаблицаДокумента.ДатаСчетаФактурыКомиссионера,
	|	ТаблицаДокумента.Покупатель,
	|	ТаблицаДокумента.НомерСчетаФактурыКомиссионера
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	| // выборка услуг
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ТаблицаДокумента.Характеристика КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) КАК Серия,
	|	НЕОПРЕДЕЛЕНО КАК НомерГТД,
	|	СУММА(ТаблицаДокумента.Количество) КАК Количество,
	|	СУММА(ТаблицаДокумента.КоличествоУпаковок) КАК КоличествоУпаковок,
	|	
	|	СУММА(ЕСТЬNULL(
	|		СуммыДокументовВВалютеРегл.СуммаБезНДСРегл,
	|		ТаблицаДокумента.СуммаСНДС - ТаблицаДокумента.СуммаНДС
	|	)) КАК СуммаБезНДС,
	|	
	|	ТаблицаДокумента.СтавкаНДС КАК СтавкаНДС,
	|	
	|	СУММА(ЕСТЬNULL(
	|		СуммыДокументовВВалютеРегл.СуммаНДСРегл,
	|		ТаблицаДокумента.СуммаНДС
	|	)) КАК СуммаНДС,
	|	
	|	ЛОЖЬ КАК ЭтоТовар,
	|	ЛОЖЬ КАК ВернутьМногооборотнуюТару,
	|	ТаблицаДокумента.Упаковка КАК Упаковка,
	|	ТаблицаДокумента.ДатаСчетаФактурыКомиссионера КАК ДатаСчетаФактурыКомиссионера,
	|	ТаблицаДокумента.Покупатель КАК Покупатель,
	|	ТаблицаДокумента.НомерСчетаФактурыКомиссионера КАК НомерСчетаФактурыКомиссионера
	|ИЗ
	|	Документ.ОтчетКомиссионера.Товары КАК ТаблицаДокумента
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ТаблицаДанныхДокументов КАК ДанныеДокументов
	|	ПО
	|		ТаблицаДокумента.Ссылка = ДанныеДокументов.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютеРегл КАК СуммыДокументовВВалютеРегл
	|	ПО
	|		ТаблицаДокумента.Ссылка = СуммыДокументовВВалютеРегл.Регистратор
	|		И ТаблицаДокумента.ИдентификаторСтроки = СуммыДокументовВВалютеРегл.ИдентификаторСтроки
	|		И СуммыДокументовВВалютеРегл.Активность
	|		И &ПересчитыватьВВалютуРегл
	|ГДЕ
	|	ТаблицаДокумента.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга)
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Ссылка,
	|	ТаблицаДокумента.НомерСтроки,
	|	ТаблицаДокумента.Номенклатура,
	|	ТаблицаДокумента.Характеристика,
	|	ТаблицаДокумента.СтавкаНДС,
	|	ТаблицаДокумента.Упаковка,
	|	ТаблицаДокумента.ДатаСчетаФактурыКомиссионера,
	|	ТаблицаДокумента.Покупатель,
	|	ТаблицаДокумента.НомерСчетаФактурыКомиссионера
	|";
	
	Запрос.Выполнить();
	
КонецПроцедуры
//-- Локализация
#КонецОбласти


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

//++ Локализация

//-- Локализация

#КонецОбласти

#Область Прочее

//++ Локализация
//-- Локализация
#КонецОбласти

#КонецОбласти
