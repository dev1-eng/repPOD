
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
	
	//++ Локализация
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Объект.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ПартияТМЦВЭксплуатации");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	УчетПрослеживаемыхТоваровЛокализация.ПроверитьЗаполнениеКоличестваПоРНПТ(Объект, Отказ, Неопределено);
	//-- Локализация
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	//++ Локализация
	
	
	//-- Локализация
	
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
		// МХ-1 
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
		КомандаПечати.Идентификатор = "МХ1";
		КомандаПечати.Представление = НСтр("ru='Акт о приеме-передаче ТМЦ на хранение (МХ-1)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КонецЕсли;

	//-- Локализация
КонецПроцедуры

#КонецОбласти

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса провведения.
//  Регистры - Строка, Структура - Список регистров продения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	//++ Локализация
	
	ТекстЗапросаТаблицаТМЦВЭксплуатации(Запрос, ТекстыЗапроса, Регистры);
	
	//-- Локализация
	
КонецПроцедуры


Процедура ДополнитьЗначенияПараметровПроведения(ЗначенияПараметровПроведения, Реквизиты) Экспорт
	
	//++ Локализация
	//-- Локализация
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаДвиженияНоменклатураДоходыРасходы(ИсходныйТекстЗапроса) Экспорт

	//++ Локализация
	
	СписокЗапросов = Новый Массив;
	СписокЗапросов.Добавить(ИсходныйТекстЗапроса); 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	&Подразделение КАК Подразделение,
	|
	|	ВЫБОР КОГДА &УчитыватьСебестоимостьТоваровПоНазначениям
	|		ТОГДА ТаблицаТовары.АналитикаУчетаНоменклатуры
	|		ИНАЧЕ ТаблицаТовары.АналитикаУчетаНоменклатурыБезНазначения
	|	КОНЕЦ КАК АналитикаУчетаНоменклатуры,
	|	&Склад КАК Склад,
	|	ТаблицаТовары.ВидЗапасов.ТипЗапасов КАК ТипЗапасов,
	|	ТаблицаТовары.ВидЗапасов КАК ВидЗапасов,
	|	
	|	ТаблицаТовары.СтатьяДоходов КАК СтатьяДоходовРасходов,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаРасходов,
	|	ТаблицаТовары.АналитикаДоходов КАК АналитикаДоходов,
	|	ТаблицаТовары.АналитикаАктивовПассивов КАК АналитикаАктивовПассивов,
	|	
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.СуммаУпр   КАК Стоимость,
	|	ТаблицаТовары.СуммаУпр   КАК СтоимостьБезНДС,
	|	ТаблицаТовары.СуммаРегл  КАК СтоимостьРегл,
	|
	|	ВЫБОР КОГДА &ФормироватьВидыЗапасовПоГруппамФинансовогоУчета ТОГДА
	|		ТаблицаТовары.ВидЗапасов
	|	ИНАЧЕ 
	|		ТаблицаТовары.Номенклатура
	|	КОНЕЦ КАК ИсточникГФУНоменклатуры,
	|	&НаправлениеДеятельности КАК НаправлениеДеятельностиСтатьи,
	|	ТаблицаТовары.Назначение.НаправлениеДеятельности КАК НаправлениеДеятельностиНоменклатуры
	|
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	&ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратИзЭксплуатации))";
	
	СписокЗапросов.Добавить(ТекстЗапроса); 
	
	ИсходныйТекстЗапроса = СтрСоединить(СписокЗапросов, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
	//-- Локализация
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаПрочиеДоходы(ИсходныйТекстЗапроса) Экспорт

	//++ Локализация
	
	СписокЗапросов = Новый Массив;
	СписокЗапросов.Добавить(ИсходныйТекстЗапроса); 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	
	|	&Организация КАК Организация,
	|	&Подразделение КАК Подразделение,
	|	ТаблицаТовары.СтатьяДоходов,
	|	ТаблицаТовары.АналитикаДоходов,
	|	
	|	ТаблицаТовары.СуммаУпр КАК Сумма,
	|	(ВЫБОР
	|		КОГДА &УправленческийУчетОрганизаций
	|			ТОГДА ТаблицаТовары.СуммаУпр
	|		ИНАЧЕ 0 КОНЕЦ) КАК СуммаУпр,
	|	(ВЫБОР
	|		КОГДА &ИспользоватьУчетПрочихДоходовРасходовРегл
	|			ТОГДА ТаблицаТовары.СуммаРегл
	|		ИНАЧЕ 0 КОНЕЦ) КАК СуммаРегл,
	|	
	|	&ХозяйственнаяОперация   КАК ХозяйственнаяОперация,
	|	&НаправлениеДеятельности КАК НаправлениеДеятельности
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.СтатьяДоходов <> НЕОПРЕДЕЛЕНО
	|	И &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратИзЭксплуатации)";
	
	СписокЗапросов.Добавить(ТекстЗапроса); 
	
	ИсходныйТекстЗапроса = СтрСоединить(СписокЗапросов, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
	//-- Локализация
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаСебестоимостьТоваров(ИсходныйТекстЗапроса) Экспорт

	//++ Локализация
	
	СписокЗапросов = Новый Массив;
	СписокЗапросов.Добавить(ИсходныйТекстЗапроса); 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)		КАК ВидДвижения,
	|	&Период										КАК Период,
	|	НЕОПРЕДЕЛЕНО КАК ПериодПродажи,
	|	ТаблицаТовары.НомерСтроки					КАК НомерСтрокиДокумента,
	|	ВЫБОР КОГДА &УчитыватьСебестоимостьТоваровПоНазначениям
	|		ТОГДА ТаблицаТовары.АналитикаУчетаНоменклатуры
	|		ИНАЧЕ ТаблицаТовары.АналитикаУчетаНоменклатурыБезНазначения
	|	КОНЕЦ										КАК АналитикаУчетаНоменклатуры,
	|	ВЫБОР КОГДА ТаблицаТовары.ЦеховаяКладовая
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыНаСкладах)
	|	КОНЕЦ										КАК РазделУчета,
	|
	|	ТаблицаТовары.ВидЗапасов					КАК ВидЗапасов,
	|
	//	партионный учет версии 2.2
	|	ВЫБОР КОГДА &ПартионныйУчетВерсии22 И &ФИФОСкользящаяОценка
	|		ТОГДА &Ссылка
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ										КАК Партия,
	|	ВЫБОР КОГДА &ПартионныйУчетВерсии22 И &ФИФОСкользящаяОценка
	|		ТОГДА ТаблицаТовары.АналитикаУчетаПартий
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ 										КАК АналитикаУчетаПартий,
	|	ВЫБОР
	|		КОГДА &ПартионныйУчетВерсии22 ТОГДА
	|			ВЫБОР
	|				КОГДА &ФормироватьВидыЗапасовПоПодразделениямМенеджерам
	|				 И &ВариантОбособленногоУчетаТоваров = ЗНАЧЕНИЕ(Перечисление.ВариантыОбособленногоУчетаТоваров.ПоПодразделению)
	|					ТОГДА &Подразделение
	|				ИНАЧЕ НЕОПРЕДЕЛЕНО
	|			КОНЕЦ
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ 										КАК АналитикаФинансовогоУчета,
	|	ВЫБОР
	|		КОГДА &ПартионныйУчетВерсии22 ТОГДА &НалогообложениеОрганизации
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ										КАК ВидДеятельностиНДС,
	|	ВЫБОР КОГДА &ПартионныйУчетВерсии22 И НЕ &ФИФОСкользящаяОценка
	|		ТОГДА ТаблицаТовары.АналитикаУчетаПартий
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ 										КАК КорАналитикаУчетаПартий,
	|	НЕОПРЕДЕЛЕНО								КАК ДокументИсточник,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.Партия) КАК ТипЗаписи,
	|
	|	ТаблицаТовары.СуммаУпр						КАК Стоимость,
	|	ТаблицаТовары.СуммаУпр						КАК СтоимостьБезНДС,
	|	ВЫБОР КОГДА &УправленческийУчетОрганизаций
	|		ТОГДА ТаблицаТовары.СуммаУпр
	|		ИНАЧЕ 0
	|	КОНЕЦ										КАК СтоимостьУпр,
	|	ТаблицаТовары.СуммаРегл						КАК СтоимостьРегл,
	|	ВЫБОР КОГДА ТаблицаТовары.СтатьяРасходов.ПринятиеКналоговомуУчету = ЛОЖЬ ТОГДА
	|		ТаблицаТовары.СуммаРегл
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ										КАК ПостояннаяРазница,
	|	0
	|												КАК ВременнаяРазница,
	|	ТаблицаТовары.Количество					КАК Количество,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОприходованиеТоваров) КАК ХозяйственнаяОперация,
	|	&Организация								КАК Организация,
	|	&Подразделение								КАК Подразделение,
	|	НЕОПРЕДЕЛЕНО								КАК КорАналитикаУчетаНоменклатуры,
	|	НЕОПРЕДЕЛЕНО								КАК КорРазделУчета,
	|	НЕОПРЕДЕЛЕНО								КАК КорВидЗапасов,
	|	НЕОПРЕДЕЛЕНО								КАК КорОрганизация,
	|	НЕОПРЕДЕЛЕНО								КАК СтатьяРасходовСписания,
	|	НЕОПРЕДЕЛЕНО								КАК АналитикаРасходов
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратИзЭксплуатации)";
	
	СписокЗапросов.Добавить(ТекстЗапроса); 
	
	ИсходныйТекстЗапроса = СтрСоединить(СписокЗапросов, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
	//-- Локализация
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаПартииТоваровОрганизаций(ИсходныйТекстЗапроса) Экспорт

	//++ Локализация
	
	СписокЗапросов = Новый Массив;
	СписокЗапросов.Добавить(ИсходныйТекстЗапроса); 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)    КАК ВидДвижения,
	|	&Период                                   КАК Период,
	|	ТаблицаТовары.НомерСтроки                 КАК НомерСтроки,
	|	&Организация                              КАК Организация,
	|	ТаблицаТовары.АналитикаУчетаНоменклатуры  КАК АналитикаУчетаНоменклатуры,
	|	ТаблицаТовары.ВидЗапасов                  КАК ВидЗапасов,
	|	ТаблицаТовары.АналитикаУчетаПартий        КАК АналитикаУчетаПартий,
	|	&Ссылка                                   КАК ДокументПоступления,
	|	ТаблицаТовары.Количество                  КАК Количество,
	|	ТаблицаТовары.СуммаУпр                    КАК Стоимость,
	|	ТаблицаТовары.СуммаУпр                    КАК СтоимостьБезНДС,
	|	ТаблицаТовары.СуммаРегл                   КАК СтоимостьРегл,
	|	ВЫБОР КОГДА ТаблицаТовары.СтатьяРасходов.ПринятиеКналоговомуУчету = ЛОЖЬ ТОГДА
	|		ТаблицаТовары.СуммаРегл
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК ПостояннаяРазница,
	|	0
	|	КАК ВременнаяРазница,
	|	ТаблицаТовары.Номенклатура                КАК Номенклатура,
	|	ТаблицаТовары.Характеристика              КАК Характеристика,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОприходованиеТоваров) КАК ХозяйственнаяОперация,
	|	ИСТИНА КАК Первичное,
	|	НЕОПРЕДЕЛЕНО КАК ДокументИсточник
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратИзЭксплуатации)
	|	И &ПартионныйУчетВерсии21";
	
	СписокЗапросов.Добавить(ТекстЗапроса); 
	
	ИсходныйТекстЗапроса = СтрСоединить(СписокЗапросов, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
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
	
	
КонецПроцедуры


// Функция получает данные для формирования печатной формы МХ - 1
//
Функция ПолучитьДанныеДляПечатнойФормыМХ1(ПараметрыПечати, МассивОбъектов) Экспорт
	
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
	|	Документ.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Склады.ИсточникИнформацииОЦенахДляПечати КАК ИсточникИнформацииОЦенахДляПечати,
	|	Склады.УчетныйВидЦены КАК ВидЦены,
	|	Склады.УчетныйВидЦены.ВалютаЦены КАК ВалютаЦены
	|ПОМЕСТИТЬ ВтШапка
	|ИЗ
	|	Документ.ПрочееОприходованиеТоваров КАК Документ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасчетСебестоимостиТоваров.Организации КАК РасчетСебестоимостиТоваровОрганизации
	|		ПО (РасчетСебестоимостиТоваровОрганизации.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(Документ.Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(Документ.Дата, МЕСЯЦ))
	|			И (РасчетСебестоимостиТоваровОрганизации.Ссылка.Проведен)
	|			И (Документ.Организация = РасчетСебестоимостиТоваровОрганизации.Организация)
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
	|	Документ.ПрочееОприходованиеТоваров.Товары КАК Товары
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
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.МестоХранения КАК Склад,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК Упаковка,
	|	ВидыЗапасов.НомерСтроки КАК НомерСтроки,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Представление ВидУпаковки,
	|	ВидыЗапасов.Количество КАК КоличествоУпаковок,
	|	ВидыЗапасов.Количество КАК Количество,
	|	КОНЕЦПЕРИОДА(ВидыЗапасов.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.СкладскаяТерритория.УчетныйВидЦены КАК ВидЦены,
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.СкладскаяТерритория.УчетныйВидЦены.ВалютаЦены КАК ВалютаЦены,
	|	Шапка.ПредварительныйРасчет КАК ПредварительныйРасчет
	|ПОМЕСТИТЬ ВтВидыЗапасов
	|ИЗ
	|	Документ.ПрочееОприходованиеТоваров.ВидыЗапасов КАК ВидыЗапасов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	|		ПО ВидыЗапасов.Ссылка = Шапка.Ссылка
	|ГДЕ
	|	ВидыЗапасов.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И ВидыЗапасов.АналитикаУчетаНоменклатуры.СкладскаяТерритория.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	|	И Шапка.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СторноСписанияНаРасходы))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВидыЗапасовТовары.Ссылка КАК Ссылка,
	|	ВидыЗапасовТовары.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	ВидыЗапасовТовары.ВидЗапасов КАК ВидЗапасов,
	|	Шапка.Организация КАК Организация,
	|	ВидыЗапасовТовары.АналитикаУчетаНоменклатуры.МестоХранения КАК Склад,
	|	ВидыЗапасовТовары.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения КАК Упаковка,
	|	ВидыЗапасовТовары.НомерСтроки КАК НомерСтроки,
	|	ВидыЗапасовТовары.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	ВидыЗапасовТовары.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	ВидыЗапасовТовары.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
	|	ВидыЗапасовТовары.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,
	|	ВидыЗапасовТовары.АналитикаУчетаНоменклатуры.Номенклатура.ЕдиницаИзмерения.Представление ВидУпаковки,
	|	ВидыЗапасовТовары.Количество КАК КоличествоУпаковок,
	|	ВидыЗапасовТовары.Количество КАК Количество,
	|	КОНЕЦПЕРИОДА(ВидыЗапасовТовары.Ссылка.Дата, ДЕНЬ) КАК ДатаПолученияЦены,
	|	ВидыЗапасовТовары.АналитикаУчетаНоменклатуры.СкладскаяТерритория.УчетныйВидЦены КАК ВидЦены,
	|	ВидыЗапасовТовары.АналитикаУчетаНоменклатуры.СкладскаяТерритория.УчетныйВидЦены.ВалютаЦены КАК ВалютаЦены,
	|	Шапка.ПредварительныйРасчет КАК ПредварительныйРасчет
	|ИЗ
	|	Документ.ПрочееОприходованиеТоваров.Товары КАК ВидыЗапасовТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтШапка КАК Шапка
	|		ПО ВидыЗапасовТовары.Ссылка = Шапка.Ссылка
	|ГДЕ
	|	ВидыЗапасовТовары.АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры В (ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар), ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
	|	И ВидыЗапасовТовары.АналитикаУчетаНоменклатуры.СкладскаяТерритория.ИсточникИнформацииОЦенахДляПечати = ЗНАЧЕНИЕ(Перечисление.ИсточникиИнформацииОЦенахДляПечати.ПоСебестоимости)
	|	И Шапка.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОприходованиеЗаСчетДоходов),
	|									ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратИзЭксплуатации),
	|									ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОприходованиеЗаСчетРасходов))
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

#КонецОбласти


#Область ФормаДокумента

Процедура ПриЧтенииСозданииНаСервере(Форма) Экспорт

	НастроитьПанельНавигации(Форма);
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Объект) Экспорт

	//++ Локализация
	
	
	//-- Локализация
	
КонецПроцедуры

Функция ОбработкаВыбора(Форма, ВыбранноеЗначение, ИмяФормы) Экспорт

	ДобавленныеСтроки = Новый Массив;
	
	//++ Локализация
	Если ИмяФормы = "Справочник.ПартииТМЦВЭксплуатации.Форма.ФормаПодбора" Тогда
		ДобавленныеСтроки = ОбработкаВыбораПодборТМЦВЭксплуатации(Форма, ВыбранноеЗначение);
	КонецЕсли;	
	//-- Локализация
	
	Возврат ДобавленныеСтроки;
	
КонецФункции
 
Функция РаспределятьПолностьюПриЗаполненииПоОрдерам(Объект) Экспорт

	РаспределятьПолностью = Истина;
	
	//++ Локализация
	РаспределятьПолностью = Объект.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации;
	//-- Локализация
	
	Возврат РаспределятьПолностью;
	
КонецФункции

Процедура ХозяйственнаяОперацияПриИзменении(Форма) Экспорт

	НастроитьПанельНавигации(Форма);
	
КонецПроцедуры

Процедура УстановитьУсловноеОформление(Форма, УсловноеОформление) Экспорт

	//++ Локализация
	
	Элементы = Форма.Элементы;
	
	
	//-- Локализация
	
КонецПроцедуры

Процедура ОперацииПриКоторыхМожноНеЗаполнятьПодразделение(МассивОпераций) Экспорт

	//++ Локализация
	МассивОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации);
	//-- Локализация
	
КонецПроцедуры

Процедура УстановитьПараметрыВыбораСтатьи(Объект, ПараметрыВыбораСтатьи) Экспорт

	//++ Локализация
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации Тогда
		
		ПараметрыВыбораСтатьи.Добавить(Новый ПараметрВыбора("ДополнитьСтатьямиДоходов", Истина));
		
		Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОприходованиеЗаСчетДоходов Тогда
			ПараметрыВыбораСтатьи.Добавить(Новый ПараметрВыбора("ДополнитьСтатьямиАктивовПассивов", Истина));
		КонецЕсли;
		
	КонецЕсли;
	
	//-- Локализация
	
КонецПроцедуры

Процедура УстановитьСоответствиеСтатейПоХозОперации(СоответствиеСтатей) Экспорт

	//++ Локализация
	СоответствиеСтатей.Вставить(Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации, ПланыВидовХарактеристик.СтатьиДоходов.ПустаяСсылка());
	//-- Локализация
	
КонецПроцедуры
 
#КонецОбласти

#Область Прочее

Процедура ДополнитьХозяйственныеОперацииДокумента(СписокОпераций) Экспорт
	
	//++ Локализация
	Если ПолучитьФункциональнуюОпцию("ИспользоватьТМЦВЭксплуатации") Тогда
		СписокОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации);
	КонецЕсли;
	//-- Локализация
	
КонецПроцедуры

Функция ЗаполнитьНаОснованииВнутреннегоПотребления(Объект, ДанныеЗаполнения, Операция) Экспорт

	//++ Локализация
	
	Если Операция = Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию Тогда
		ЗаполнитьДокументНаОснованииПередачиВЭксплуатацию(Объект, ДанныеЗаполнения);
		Возврат Истина;
	КонецЕсли;

	//-- Локализация
	
	Возврат Ложь;
	
КонецФункции

Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт

	//++ Локализация
	
	МассивВсехРеквизитов.Добавить("Товары.ФизическоеЛицо");
	МассивВсехРеквизитов.Добавить("Товары.ПартияТМЦВЭксплуатации");
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации Тогда
		МассивРеквизитовОперации.Добавить("ВидЦены");
		МассивРеквизитовОперации.Добавить("Валюта");
		МассивРеквизитовОперации.Добавить("Товары.Цена");
		МассивРеквизитовОперации.Добавить("Товары.Сумма");
		МассивРеквизитовОперации.Добавить("Товары.АналитикаДоходов");
		МассивРеквизитовОперации.Добавить("Товары.АналитикаАктивовПассивов");
		МассивРеквизитовОперации.Добавить("Товары.ФизическоеЛицо");
		МассивРеквизитовОперации.Добавить("Товары.ПартияТМЦВЭксплуатации");
		МассивРеквизитовОперации.Добавить("Товары.НомерГТД");
	КонецЕсли;	
	
	//-- Локализация
	
КонецПроцедуры

Процедура ЗаполнитьИменаЭлементовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехЭлементов, МассивЭлементовОперации) Экспорт

	//++ Локализация
	
	МассивВсехЭлементов.Добавить("ТоварыПодобратьТМЦВЭксплуатации");
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации Тогда
		МассивЭлементовОперации.Добавить("ТоварыПерезаполнитьПоПриемке");
		МассивЭлементовОперации.Добавить("ТоварыЗаполнитьЦеныПоВидуЦен");
		МассивЭлементовОперации.Добавить("ТоварыИзменитьКачество");
		МассивЭлементовОперации.Добавить("ТоварыПодобратьТМЦВЭксплуатации");
		МассивЭлементовОперации.Добавить("ТоварыСтранаПроисхождения");
	КонецЕсли;	
	
	//-- Локализация
	
КонецПроцедуры

Процедура УстановитьУсловноеОформлениеСписка(Список) Экспорт

	//++ Локализация
	
	// Возврат из эксплуатации
	
	Элемент = Список.КомпоновщикНастроек.ФиксированныеНастройки.УсловноеОформление.Элементы.Добавить();
	Элемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("Тип");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ХозяйственнаяОперация");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тип");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Тип("ДокументСсылка.ПрочееОприходованиеТоваров");
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Возврат из эксплуатации'"));
	
	//-- Локализация
	
КонецПроцедуры
 
#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

//++ Локализация

Функция ТекстЗапросаТаблицаТМЦВЭксплуатации(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ТМЦВЭксплуатации";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Организация КАК Организация,
	|	&Подразделение КАК Подразделение,
	|	ТабличнаяЧасть.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ТабличнаяЧасть.Номенклатура КАК Номенклатура,
	|	ТабличнаяЧасть.Характеристика КАК Характеристика,
	|	ТабличнаяЧасть.ПартияТМЦВЭксплуатации КАК Партия,
	|	-ТабличнаяЧасть.Количество КАК Количество
	|ИЗ
	|	Документ.ПрочееОприходованиеТоваров.Товары КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Ссылка
	|	И ТабличнаяЧасть.Ссылка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратИзЭксплуатации)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции


//-- Локализация

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

//++ Локализация

Функция ОбработкаВыбораПодборТМЦВЭксплуатации(Форма, МассивВыбранных)
	
	Форма.Модифицированность = Истина;
	Объект = Форма.Объект;
	
	ДобавленныеСтроки = Новый Массив;
	Для Каждого ЭлементМассива Из МассивВыбранных Цикл
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементМассива);
		ДобавленныеСтроки.Добавить(НоваяСтрока);
	КонецЦикла;
	
	Возврат ДобавленныеСтроки;
	
КонецФункции

//-- Локализация

#КонецОбласти

#Область Прочее

//++ Локализация

Процедура ЗаполнитьДокументНаОснованииПередачиВЭксплуатацию(Объект, ДокументОснование)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВозвратИзЭксплуатации) КАК ХозяйственнаяОперация,
	|	ВнутреннееПотреблениеТоваров.Ссылка КАК ДокументОснование,
	|	ВнутреннееПотреблениеТоваров.Склад КАК Склад,
	|	ВнутреннееПотреблениеТоваров.Подразделение КАК Подразделение,
	|	ВнутреннееПотреблениеТоваров.Организация КАК Организация,
	|	ВнутреннееПотреблениеТоваров.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	НЕ ВнутреннееПотреблениеТоваров.Проведен КАК ЕстьОшибкиПроведен
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров КАК ВнутреннееПотреблениеТоваров
	|ГДЕ
	|	ВнутреннееПотреблениеТоваров.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Назначение КАК Назначение,
	|	&Ссылка КАК ПередачаВЭксплуатацию,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Количество КАК Количество,
	|	Товары.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Товары.ПартияТМЦВЭксплуатации КАК ПартияТМЦВЭксплуатации
	|ИЗ
	|	Документ.ВнутреннееПотреблениеТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаШапка = МассивРезультатов[0].Выбрать();
	ВыборкаШапка.Следующий();
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(ДокументОснование, , ВыборкаШапка.ЕстьОшибкиПроведен);
	
	ЗаполнитьЗначенияСвойств(Объект, ВыборкаШапка);
	
	Объект.Товары.Загрузить(МассивРезультатов[1].Выгрузить());
	
КонецПроцедуры


//-- Локализация

#КонецОбласти

#КонецОбласти
