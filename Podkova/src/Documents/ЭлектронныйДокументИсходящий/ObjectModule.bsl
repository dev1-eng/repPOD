#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ТипЗначенияДанныеЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ОбщегоНазначения.ЭтоСсылка(ТипЗначенияДанныеЗаполнения) Тогда
		ОснованиеСсылка = ДанныеЗаполнения;
		
		ТребуетсяПодтверждение = Истина;
		ТипДокумента = Перечисления.ТипыЭД.Прочее;
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЭлектронныйДокументВходящий") 
			ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЭлектронныйДокументИсходящий") Тогда
			СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения,
			"Контрагент, Организация, ДоговорКонтрагента, ТипДокумента, ТребуетсяПодтверждение");
			ТипДокумента			= СтруктураРеквизитов.ТипДокумента;
			ТребуетсяПодтверждение	= СтруктураРеквизитов.ТребуетсяПодтверждение;
			Контрагент				= СтруктураРеквизитов.Контрагент;
			Организация				= СтруктураРеквизитов.Организация;
			ДоговорКонтрагента		= СтруктураРеквизитов.ДоговорКонтрагента;
		Иначе
			Если СтрНайти(ДанныеЗаполнения.Метаданные().ПолноеИмя(), "ПрисоединенныеФайлы") > 0 Тогда
				ОснованиеСсылка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "ВладелецФайла");
				ПоместитьВложениеВоВременноеХранилище(ДанныеЗаполнения, ОснованиеСсылка);
			Иначе
				ОснованиеСсылка = ДанныеЗаполнения;
			КонецЕсли;
			СтруктураРеквизитов = ОбменСКонтрагентамиСлужебный.ЗаполнитьПараметрыЭДПоИсточнику(ОснованиеСсылка);
			Если ТипЗнч(СтруктураРеквизитов) = Тип("Структура") Тогда
				Если ЗначениеЗаполнено(СтруктураРеквизитов.Контрагент) И Контрагент <> СтруктураРеквизитов.Контрагент Тогда
					Контрагент = СтруктураРеквизитов.Контрагент;
				КонецЕсли;
				Если ЗначениеЗаполнено(СтруктураРеквизитов.Организация) И Организация <> СтруктураРеквизитов.Организация Тогда
					Организация = СтруктураРеквизитов.Организация;
				КонецЕсли;
				Если ЗначениеЗаполнено(СтруктураРеквизитов.ДоговорКонтрагента) И ДоговорКонтрагента <> СтруктураРеквизитов.ДоговорКонтрагента Тогда
					ДоговорКонтрагента = СтруктураРеквизитов.ДоговорКонтрагента;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ТаблицаИдентификаторов = Новый ТаблицаЗначений;
		Если Метаданные.Документы.Содержит(ОснованиеСсылка.Метаданные()) Тогда
			// Т.к. документом-основанием может быть документ ИБ, сформированный на основании входящего ЭД,
			// то чтобы на стороне получателя данный документ правильно определил основание, в качестве
			// идентификатора передается НомерЭД (всегда является идентификатором документа ИБ, на основании
			// которого формируется ЭДО).
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ЭлектронныйДокументВходящий.Ссылка КАК СообщениеОбмена
			|ПОМЕСТИТЬ втВладельцы
			|ИЗ
			|	Документ.ЭлектронныйДокументВходящий КАК ЭлектронныйДокументВходящий
			|ГДЕ
			|	ЭлектронныйДокументВходящий.Ссылка = &ДокументОснование
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ЭлектронныйДокументИсходящий.Ссылка
			|ИЗ
			|	Документ.ЭлектронныйДокументИсходящий КАК ЭлектронныйДокументИсходящий
			|ГДЕ
			|	ЭлектронныйДокументИсходящий.Ссылка = &ДокументОснование
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ЭлектронныйДокументИсходящийДокументыОснования.Ссылка
			|ИЗ
			|	Документ.ЭлектронныйДокументИсходящий.ДокументыОснования КАК ЭлектронныйДокументИсходящийДокументыОснования
			|ГДЕ
			|	ЭлектронныйДокументИсходящийДокументыОснования.ДокументОснование = &ДокументОснование
			|	И НЕ ЭлектронныйДокументИсходящийДокументыОснования.Ссылка.ВидЭД = ЗНАЧЕНИЕ(Перечисление.ВидыЭД.ПроизвольныйЭД)
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ЭлектронныйДокументВходящийДокументыОснования.Ссылка
			|ИЗ
			|	Документ.ЭлектронныйДокументВходящий.ДокументыОснования КАК ЭлектронныйДокументВходящийДокументыОснования
			|ГДЕ
			|	ЭлектронныйДокументВходящийДокументыОснования.ДокументОснование = &ДокументОснование
			|	И НЕ ЭлектронныйДокументВходящийДокументыОснования.Ссылка.ВидЭД = ЗНАЧЕНИЕ(Перечисление.ВидыЭД.ПроизвольныйЭД)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ЭДПрисоединенныеФайлы.НомерЭД КАК ИдентификаторДокументаОснования,
			|	ЭДПрисоединенныеФайлы.УникальныйИД КАК ИдентификаторЭДДокументаОснования
			|ИЗ
			|	втВладельцы КАК втВладельцы
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЭДПрисоединенныеФайлы КАК ЭДПрисоединенныеФайлы
			|		ПО втВладельцы.СообщениеОбмена = ЭДПрисоединенныеФайлы.ВладелецФайла
			|			И (ЭДПрисоединенныеФайлы.ТипЭлементаВерсииЭД В (&ОсновныеТипыЭлектронныхДокументов))";
			
			Запрос.УстановитьПараметр("ДокументОснование", ОснованиеСсылка);
			Запрос.УстановитьПараметр("ОсновныеТипыЭлектронныхДокументов", ОбменСКонтрагентамиСлужебный.ОсновныеТипыЭД());
			УстановитьПривилегированныйРежим(Истина);
			ТаблицаИдентификаторов = Запрос.Выполнить().Выгрузить();
			УстановитьПривилегированныйРежим(Ложь);
			Если ТаблицаИдентификаторов.Количество() = 0 Тогда
				СтрокаИдентификатора = ТаблицаИдентификаторов.Добавить();
				СтрокаИдентификатора.ИдентификаторДокументаОснования = Строка(ОснованиеСсылка.УникальныйИдентификатор());
				СтрокаИдентификатора.ИдентификаторЭДДокументаОснования = Строка(ОснованиеСсылка.УникальныйИдентификатор());
			КонецЕсли;
			
			ИдентификаторыОснованийВладельцаФайла.Загрузить(ТаблицаИдентификаторов);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный = Справочники.Пользователи.ПустаяСсылка();
	
	УдалитьПрофильНастроекЭДО = Неопределено;
	УдалитьНастройкаЭДО       = Неопределено;
	СостояниеЭДО       = Неопределено;
	ДатаИзмененияСостоянияЭДО = Дата(1,1,1);
	ДатаДокументаОтправителя  = Дата(1,1,1);
	НомерДокументаОтправителя = "";
	ПричинаОтклонения = "";
	УникальныйИД = "";
	Прочитан = Ложь;
	
	СписокПодписантов.Очистить();
	
	ОчиститьИсториюОбработки();
	
КонецПроцедуры

Процедура ПоместитьВложениеВоВременноеХранилище(ПрисоединенныйФайлСсылка, ВладелецФайла)
	
	СтруктураФайла = РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайлСсылка, Новый УникальныйИдентификатор);
	СтруктураФайла.Вставить("ОтносительныйПуть", "");
	АдресХранилища = ПоместитьВоВременноеХранилище(СтруктураФайла, Новый УникальныйИдентификатор);
	ОбменСКонтрагентамиСлужебный.ПоместитьПараметрВПараметрыКлиентаНаСервере(ВладелецФайла, АдресХранилища);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоНовый() Тогда
				
		Если ВидЭД = Перечисления.ВидыЭД.ПроизвольныйЭД Тогда
			
			Если ПустаяСтрока(Номер) Тогда
				УстановитьНовыйНомер();
			КонецЕсли;
			
			Если ПустаяСтрока(НомерДокументаОтправителя) Тогда
				НомерДокументаОтправителя = Номер;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(ДатаДокументаОтправителя) Тогда
				ДатаДокументаОтправителя = Дата;
			КонецЕсли;
			
			НаименованиеДокументаОтправителя = ТипДокумента;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьОтветственного();
	
	ЗаполнитьИсториюОбработки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьОтветственного()
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		ОтветственныйПоЭД = Неопределено;
		ОбменСКонтрагентамиПереопределяемый.ПолучитьОтветственногоПоЭД(Контрагент, Организация, ДоговорКонтрагента, ОтветственныйПоЭД);
		Ответственный = ?(ЗначениеЗаполнено(ОтветственныйПоЭД), ОтветственныйПоЭД, Пользователи.ТекущийПользователь());
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьИсториюОбработки() 
	
	СостоянияПодписан = Новый Массив;
	СостоянияОтправлен = Новый Массив;
	СостоянияАннулирован = Новый Массив;
	
	ДатаСеанса = ТекущаяДатаСеанса();
	
	СостоянияОтправлен.Добавить(Перечисления.СостоянияВерсийЭД.ОбменЗавершен);
	СостоянияОтправлен.Добавить(Перечисления.СостоянияВерсийЭД.ОбменЗавершенСИсправлением);
	СостоянияОтправлен.Добавить(Перечисления.СостоянияВерсийЭД.ОжидаетсяИзвещениеОПолучении);
	СостоянияОтправлен.Добавить(Перечисления.СостоянияВерсийЭД.ОжидаетсяПодтверждение);
	СостоянияОтправлен.Добавить(Перечисления.СостоянияВерсийЭД.ОжидаетсяПодтверждениеОператора);
	СостоянияОтправлен.Добавить(Перечисления.СостоянияВерсийЭД.ОжидаетсяОтправкаПолучателю);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СостоянияПодписан, СостоянияОтправлен);
	СостоянияПодписан.Добавить(Перечисления.СостоянияВерсийЭД.ОжидаетсяОтправка);
	СостоянияПодписан.Добавить(Перечисления.СостоянияВерсийЭД.ОжидаетсяПередачаОператору);
	
	СостоянияАннулирован.Добавить(Перечисления.СостоянияВерсийЭД.Аннулирован);
	
	Если Не ЗначениеЗаполнено(ДатаПодписания)
		И СостоянияПодписан.Найти(СостояниеЭДО) <> Неопределено Тогда
		ДатаПодписания = ДатаСеанса;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаОтправки)
		И СостоянияОтправлен.Найти(СостояниеЭДО) <> Неопределено Тогда
		ДатаОтправки = ДатаСеанса;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ДатаАннулирования)
		И СостоянияАннулирован.Найти(СостояниеЭДО) <> Неопределено Тогда
		ДатаАннулирования = ДатаСеанса;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьИсториюОбработки()
	
	ДатаПодписания = Дата(1, 1, 1);
	ДатаОтправки = Дата(1, 1, 1);
	ДатаАннулирования = Дата(1, 1, 1);
	
КонецПроцедуры

#КонецОбласти

#Иначе
	
	ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
	
#КонецЕсли