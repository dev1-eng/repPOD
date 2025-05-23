////////////////////////////////////////////////////////////////////////////////
// ОбменСКонтрагентамиКлиентСервер: механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает текстовое представление версии электронного документа.
//
// Параметры:
//  СсылкаНаВладельца - Ссылка - объект, состояние версии электронного документа которого необходимо получить.
//  ЭлементДоступен - Булево - установка гиперссылки.
//
// Возвращаемое значение:
//  Строка - текстовое представление.
//
Функция ПолучитьТекстСостоянияЭД(СсылкаНаВладельца, ЭлементДоступен = Истина) Экспорт
	
	Результат = ОбменСКонтрагентамиСлужебныйВызовСервера.ТекстСостоянияЭД(СсылкаНаВладельца, ЭлементДоступен);
	
	Возврат Результат;
	
КонецФункции

// Формирование текстового представления рекламы по ЭДО.
//
// Параметры:
//  ДополнительнаяИнформация - Структура - с полями:
//   * Картинка - Картинка - картинка из библиотеки картинок;
//   * Текст - Строка - форматированный текст надписи с навигационными ссылками.
//  МассивСсылок - Массив - список ссылок на объекты.
//
// Возвращаемое значение:
//  Строка - возврат строки рекламы.
//
Функция ПриВыводеНавигационнойСсылкиВФормеОбъектаИБ(ДополнительнаяИнформация, МассивСсылок) Экспорт
	
	Если Не ЗначениеЗаполнено(МассивСсылок) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ОбменСКонтрагентамиСлужебныйВызовСервера.ЕстьПравоНастройкиОбмена() Тогда
		Возврат "";
	КонецЕсли;
	
	ПараметрыЭД = Неопределено;
	СтатусПодключения = Неопределено;
	Если Не ОбменСКонтрагентамиСлужебныйВызовСервера.НастройкаЭДСуществует(МассивСсылок[0], ПараметрыЭД)
			ИЛИ ПараметрыЭД.Свойство("СтатусПодключения", СтатусПодключения) И СтатусПодключения = ПредопределенноеЗначение("Перечисление.СтатусыПриглашений.Отклонено") Тогда
		
		ТекстНавигационнойСсылки = "";
		ОбменСКонтрагентамиСлужебныйВызовСервера.ЗаполнитьТекстПриглашенияКЭДО(ТекстНавигационнойСсылки, ПараметрыЭД, МассивСсылок[0], Ложь);
		Если ЗначениеЗаполнено(ТекстНавигационнойСсылки) Тогда
			ШаблонНавигационнойСсылки = НСтр("ru = '<a href = ""Реклама1СЭДО"">%1</a>'");
			ДополнительнаяИнформация.Текст    = СтрШаблон(ШаблонНавигационнойСсылки, ТекстНавигационнойСсылки);
			ДополнительнаяИнформация.Картинка = БиблиотекаКартинок.ЭмблемаСервиса1СЭДО;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Заполнение состояния ЭДО.
//
// Параметры:
//  Форма					 - Форма - текущая форма.
//  ДокументСсылка			 - ДокументСсылка - ссылка на документ.
//  ДекорацияСостояниеЭДО	 - ЭлементФормы - элемент для надписи состояния.
//  ГруппаСостояниеЭДО		 - ГруппаЭлементыФормы - группа элементов ЭДО.
//
Процедура ЗаполнитьСостояниеЭДО(Форма, ДокументСсылка, ДекорацияСостояниеЭДО, ГруппаСостояниеЭДО = Неопределено) Экспорт
	
	ИспользоватьОбменЭД = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЗначениеФункциональнойОпции("ИспользоватьОбменЭД");
	ИспользоватьВнутренниеЭД = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ЗначениеФункциональнойОпции("ИспользоватьВнутренниеДокументыЭДО");
	
	ПараметрыЭД = ОбменСКонтрагентамиСлужебныйВызовСервера.ЗаполнитьПараметрыЭДПоИсточнику(ДокументСсылка);
	
	Если ПараметрыЭД.НаправлениеЭД = ПредопределенноеЗначение("Перечисление.НаправленияЭД.Внутренний") Тогда
		
		Если ГруппаСостояниеЭДО = Неопределено Тогда
			ДекорацияСостояниеЭДО.Видимость = ИспользоватьВнутренниеЭД И ИспользоватьОбменЭД;
		Иначе
			ГруппаСостояниеЭДО.Видимость = ИспользоватьВнутренниеЭД И ИспользоватьОбменЭД;
		КонецЕсли;
		
		Если Не ИспользоватьОбменЭД Или Не ИспользоватьВнутренниеЭД Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли; 
	
	Если ГруппаСостояниеЭДО = Неопределено Тогда
		ДекорацияСостояниеЭДО.Видимость = ИспользоватьОбменЭД;
	Иначе
		ГруппаСостояниеЭДО.Видимость = ИспользоватьОбменЭД;
	КонецЕсли;
	
	Если Не ИспользоватьОбменЭД Тогда
		Возврат;
	КонецЕсли;
	
	ДекорацияДоступность = Истина;
	ТекстСостояния = ПолучитьТекстСостоянияЭД(ДокументСсылка, ДекорацияДоступность);
	
	Если ПустаяСтрока(ТекстСостояния) Тогда
		Если ГруппаСостояниеЭДО = Неопределено Тогда
			ДекорацияСостояниеЭДО.Видимость = Ложь;
		Иначе
			ГруппаСостояниеЭДО.Видимость = Ложь;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ДекорацияСостояниеЭДО.Заголовок = ТекстСостояния;
	ДекорацияСостояниеЭДО.Доступность = ДекорацияДоступность;
	
КонецПроцедуры

// Возвращает имя формы - ФормаСписка или ФормаЭлемента.
// 
// Параметры:
//  Форма - Форма - требуемая форма.
//
// Возвращаемое значение:
//  Строка - имя формы.
//
Функция КраткоеИмяФормы(Форма)  Экспорт
	
	Если ТипЗнч(Форма) = Тип("ФормаКлиентскогоПриложения") Тогда
		ИмяФормы = Форма.ИмяФормы;
	Иначе
		ИмяФормы = Форма;
	КонецЕсли;

	ЧастиИмени = СтрРазделить(ИмяФормы, ".");
	КраткоеИмяФормы = ЧастиИмени[ЧастиИмени.Количество()-1];
	
	Возврат КраткоеИмяФормы;

КонецФункции

#Область Тарификация

// Возвращает идентификатор услуги обмена электронными документами для осуществления тарификации.
// 
// Возвращаемое значение:
//  Строка - идентификатор услуги.
//
Функция ИдентификаторУслугиОбменаЭлектроннымиДокументами() Экспорт
	
	Возврат "1c-edo-access";
	
КонецФункции

#КонецОбласти

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать новые:
// См. ОбменСКонтрагентами.СформироватьПодписатьИОтправитьСлужебныеЭД
// См. ОбменСКонтрагентамиКлиент.СформироватьПодписатьИОтправитьСлужебныеЭД
// В процедуре выполняются действия по служебным ЭД (извещение о получении, уведомление об уточнении):
// формирование, утверждение, подписание, отправка.
//
// Параметры:
//  МассивЭД - массив - содержит ссылки на ЭД, по которым требуется сформировать служебные ЭД (электронные
//    документы, владельцы обрабатываемых служебных ЭД).
//  ВидЭД - перечисление - вид ЭД, которые надо обработать (может принимать значения: Извещение о получении
//    и уведомление об уточнении).
//  ТекстУведомления - строка - текст уведомления, введенный пользователем, отклонившим ЭД (имеет смысл,
//    только для ВидЭД = УведомлениеОбУточнении).
//  ДопПараметры - структура - структура дополнительных параметров.
//  ОписаниеОповещения - ОписаниеОповещения - оповещение, вызываемое после выполнения метода.
//
Процедура СформироватьПодписатьИОтправитьСлужебныеЭД(МассивЭД,
	ВидЭД, ТекстУведомления = "", ДопПараметры = Неопределено, ОписаниеОповещения = Неопределено) Экспорт
	
	#Если Клиент Тогда
		ОбменСКонтрагентамиКлиент.СформироватьПодписатьИОтправитьСлужебныеЭД(
			МассивЭД, ВидЭД, ТекстУведомления, ДопПараметры, ОписаниеОповещения);
	#Иначе
		ОбменСКонтрагентами.СформироватьПодписатьИОтправитьСлужебныеЭД(
			МассивЭД, ВидЭД, ТекстУведомления, ДопПараметры, ОписаниеОповещения);
	#КонецЕсли
			
КонецПроцедуры

#КонецОбласти

// Обновляет список команд в зависимости от текущего контекста.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, для которой требуется обновление команд.
//   Источник - ДанныеФормыСтруктура, ТаблицаФормы - контекст для проверки условий (Форма.Объект или Форма.Элементы.Список).
//
Процедура ОбновитьКоманды(Форма, Источник) Экспорт
	Структура = Новый Структура("ПараметрыУправленияВидимостьюЭДО", Null);
	ЗаполнитьЗначенияСвойств(Структура, Форма);
	ПараметрыКлиента = Структура.ПараметрыУправленияВидимостьюЭДО;
	Если ТипЗнч(ПараметрыКлиента) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("ТаблицаФормы") Тогда
		ДоступностьКоманд = (Источник.ТекущаяСтрока <> Неопределено);
	Иначе
		ДоступностьКоманд = Истина;
	КонецЕсли;
	
	Если Не ДоступностьКоманд Или Не ПараметрыКлиента.ЕстьУсловияВидимости Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныеОбъекты             = Новый Массив;
	ПроверятьОписаниеТипов       = Ложь;
	
	Если ТипЗнч(Источник) = Тип("ТаблицаФормы") Тогда
		ВыделенныеСтроки = Источник.ВыделенныеСтроки;
		Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			Если ТипЗнч(ВыделеннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
				Продолжить;
			КонецЕсли;
			ТекущаяСтрока = Источник.ДанныеСтроки(ВыделеннаяСтрока);
			Если ТекущаяСтрока <> Неопределено Тогда
				ВыбранныеОбъекты.Добавить(ТекущаяСтрока);
			КонецЕсли;
		КонецЦикла;
	Иначе
		ВыбранныеОбъекты.Добавить(Источник);
	КонецЕсли;
	
	ОбъектыДляПроверкиАлгоритмом = Новый Массив;
	Для Каждого Объект Из ВыбранныеОбъекты Цикл
		Если ТипЗнч(Объект) = Тип("ДанныеФормыСтруктура") Тогда
			СсылкаНаИсточник = Объект.Ссылка;
		Иначе
			СсылкаНаИсточник = Объект;
		КонецЕсли;
		ОбъектыДляПроверкиАлгоритмом.Добавить(СсылкаНаИсточник);
	КонецЦикла;
	
	// В эту переменную будем записывать значения, вычисленные по алгоритмам проверки, чтобы минимизировать
	// клиент-серверные вызовы.
	КэшЗначенийАлгоритмовПроверки = Новый Соответствие;
	
	Для Каждого Команда Из ПараметрыКлиента.КомандыСУсловиямиВидимости Цикл
		КомандаЭлемент = Форма.Элементы[Команда.ИмяВФорме];
		Видимость = Истина;
		
		Для Каждого Объект Из ВыбранныеОбъекты Цикл
			
			ЗначениеСтроки = Неопределено;
			Если Объект.Свойство(Команда.ИмяРеквизитаУсловия, ЗначениеСтроки) Тогда
				Видимость = Команда.ЗначениеУсловия = ЗначениеСтроки;
				
				Если Не Видимость Тогда
					Прервать;
				КонецЕсли;
				
			ИначеЕсли ЗначениеЗаполнено(Команда.ИмяАлгоритмаПроверкиУсловия) Тогда
				// Если задан алгоритм проверки, выполняем его, кэшируя результат в разрезе имени реквизита проверки.
				ЗначениеСтроки = КэшЗначенийАлгоритмовПроверки[Команда.ИмяАлгоритмаПроверкиУсловия];
				
				Если ЗначениеСтроки = Неопределено Тогда
					ЗначениеСтроки = ОбменСКонтрагентамиСлужебныйВызовСервера.ПроверитьУсловиеПоАлгоритму(ОбъектыДляПроверкиАлгоритмом,
						Команда.ИмяАлгоритмаПроверкиУсловия);
					КэшЗначенийАлгоритмовПроверки.Вставить(Команда.ИмяАлгоритмаПроверкиУсловия, ЗначениеСтроки);
				КонецЕсли;
					
				Видимость = Команда.ЗначениеУсловия = ЗначениеСтроки;
				
				Если Не Видимость Тогда
					Прервать;
				КонецЕсли;
				
			ИначеЕсли ТипЗнч(Источник) = Тип("ТаблицаФормы") Тогда
				// В динамическом списке нет поля для проверки условий видимости
				Возврат;
			Иначе 
				// Для формы объекта в этом случае показываем все команды.
			КонецЕсли;
		КонецЦикла;
			
		КомандаЭлемент.Видимость = Видимость;
	КонецЦикла;
	
КонецПроцедуры

#Область СопоставлениеНоменклатуры

// Возвращает набор данных, представляющий номенклатуру информационной базы.
//
// Параметры:
//  Номенклатура   - ОпределяемыйТип.НоменклатураБЭД               - значение для инициализации выходного свойства Номенклатура.
//  Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатурыБЭД - значение для инициализации выходного свойства Характеристика.
//  Упаковка       - ОпределяемыйТип.УпаковкаНоменклатурыБЭД       - значение для инициализации выходного свойства Упаковка.
//
// Возвращаемое значение:
//  Структура - данные, представляющие номенклатуру информационной базы:
//   * Номенклатура   - ОпределяемыйТип.НоменклатураБЭД, Неопределено               - номенклатура ИБ. Неопределено, если не инициализировано.
//   * Характеристика - ОпределяемыйТип.ХарактеристикаНоменклатурыБЭД, Неопределено - характеристика номенклатуры ИБ. Неопределено, если не инициализировано.
//   * Упаковка       - ОпределяемыйТип.УпаковкаНоменклатурыБЭД, Неопределено       - упаковка номенклатуры информационной базы. Неопределено, если не инициализировано.
//
Функция НоваяНоменклатураИнформационнойБазы(Знач Номенклатура = Неопределено, Знач Характеристика = Неопределено, Знач Упаковка = Неопределено) Экспорт
	
	Если ОбменСКонтрагентамиСлужебныйКлиентСервер.ПодсистемаСопоставленияНоменклатурыСуществует() Тогда
		Возврат ОбменСКонтрагентамиСлужебныйКлиентСервер.МодульСопоставлениеНоменклатурыКонтрагентовКлиентСервер().НоваяНоменклатураИнформационнойБазы(
			Номенклатура, Характеристика, Упаковка);
	КонецЕсли;
	
	НоменклатураИБ = ОбменСКонтрагентамиСлужебныйКлиентСервер.НоваяНоменклатураИнформационнойБазы(Номенклатура, Характеристика, Упаковка);
	
	Возврат НоменклатураИБ;
	
КонецФункции

// Возвращает набор данных, представляющий номенклатуру контрагента.
//
// Параметры:
//  Владелец      - ОпределяемыйТип.ВладелецНоменклатурыБЭД - значение для инициализации выходного свойства Владелец.
//  Идентификатор - Строка                                  - значение для инициализации выходного свойства Идентификатор.
//
// Возвращаемое значение:
//  Структура - данные, представляющие номенклатуру контрагента:
//   * Владелец                           - ОпределяемыйТип.ВладелецНоменклатурыБЭД, Неопределено - владелец номенклатуры. Неопределено, если не инициализировано.
//   * Идентификатор                      - Строка - идентификатор записи по комбинации: номенклатура#характеристика#упаковка.
//   * Наименование                       - Строка - наименование номенклатуры.
//   * Характеристика                     - Строка - наименование характеристики номенклатуры.
//   * ЕдиницаИзмерения                   - Строка - единица измерения номенклатуры.
//   * ЕдиницаИзмеренияКод                - Строка - код единицы измерения номенклатуры.
//   * Артикул                            - Строка - артикул номенклатуры.
//   * СтавкаНДС                          - Строка - ставка НДС номенклатуры. Ключ из соответствия, 
//                                                   заданного в методе ОбменСКонтрагентамиПереопределяемый.ЗаполнитьСоответствиеСтавокНДС
//   * ШтрихкодКомбинации                 - Строка - штрихкод комбинации: номенклатура, характеристика, упаковка.
//   * ШтрихкодыНоменклатуры              - Строка - штрихкоды номенклатуры через запятую.
//   * ИдентификаторНоменклатурыСервиса   - Строка - идентификатор в сервисе 1С:Номенклатура.
//   * ИдентификаторХарактеристикиСервиса - Строка - идентификатор характеристики в сервисе 1С:Номенклатура.
//   * ИдентификаторНоменклатуры          - Строка - идентификатор номенклатуры.
//   * ИдентификаторХарактеристики        - Строка - идентификатор характеристики.
//   * ИдентификаторУпаковки              - Строка - идентификатор упаковки.
//   * ИсторияИдентификаторов - Массив - история версий идентификаторов для данной номенклатуры (служебный).
//
Функция НоваяНоменклатураКонтрагента(Знач Владелец = Неопределено, Знач Идентификатор = Неопределено) Экспорт
	
	Если ОбменСКонтрагентамиСлужебныйКлиентСервер.ПодсистемаСопоставленияНоменклатурыСуществует() Тогда
		Возврат ОбменСКонтрагентамиСлужебныйКлиентСервер.МодульСопоставлениеНоменклатурыКонтрагентовКлиентСервер().НоваяНоменклатураКонтрагента(
			Владелец, Идентификатор);
	КонецЕсли;
	
	НоменклатураКонтрагента = ОбменСКонтрагентамиСлужебныйКлиентСервер.НоваяНоменклатураКонтрагента(Владелец, Идентификатор);
	
	Возврат НоменклатураКонтрагента;
	
КонецФункции

// Возвращает структуру свойств номенклатуры ИБ.
//
// Возвращаемое значение:
//  Структура - свойства номенклатуры информационной базы:
//   * ИспользоватьХарактеристики           - Булево - признак использования характеристик. По умолчанию Ложь.
//   * ИспользоватьУпаковки                 - Булево - признак использования упаковок. По умолчанию Ложь.
//   * ОбязательноеЗаполнениеХарактеристики - Булево - признак обязательного заполнения характеристик при их использовании. По умолчанию Истина.
//
Функция НовыеСвойстваНоменклатурыИБ() Экспорт
	
	Если ОбменСКонтрагентамиСлужебныйКлиентСервер.ПодсистемаСопоставленияНоменклатурыСуществует() Тогда
		Возврат ОбменСКонтрагентамиСлужебныйКлиентСервер.МодульСопоставлениеНоменклатурыКонтрагентовКлиентСервер().НовыеСвойстваНоменклатурыИБ();
	КонецЕсли;

	СвойствоНоменклатуры = Новый Структура;
	СвойствоНоменклатуры.Вставить("ИспользоватьХарактеристики"          , Ложь);
	СвойствоНоменклатуры.Вставить("ИспользоватьУпаковки"                , Ложь);
	СвойствоНоменклатуры.Вставить("ОбязательноеЗаполнениеХарактеристики", Истина);
	
	Возврат СвойствоНоменклатуры;
	
КонецФункции

#КонецОбласти

#КонецОбласти
