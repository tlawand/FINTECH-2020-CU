CREATE TABLE "card_holder" (
	"id" SERIAL NOT NULL PRIMARY KEY,
	"name" VARCHAR(255) NOT NULL
);

CREATE TABLE "credit_card" (
	"card" VARCHAR(20) NOT NULL PRIMARY KEY,
	"id_card_holder" INT NOT NULL,
	FOREIGN KEY ("id_card_holder") REFERENCES "card_holder" ("id")
);

CREATE TABLE "merchant_category" (
	"id" SERIAL NOT NULL PRIMARY KEY,
	"name" VARCHAR(255) NOT NULL
);

CREATE TABLE "merchant" (
	"id" SERIAL NOT NULL PRIMARY KEY,
	"name" VARCHAR(255) NOT NULL,
	"id_merchant_category" SERIAL  NOT NULL,
	FOREIGN KEY ("id_merchant_category") REFERENCES "merchant_category" ("id")
);

CREATE TABLE "transaction" (
	"id" SERIAL NOT NULL PRIMARY KEY,
	"date" DATE NOT NULL,
	"amount" FLOAT NOT NULL,
	"card" VARCHAR(20) NOT NULL,
	"id_merchant" INT NOT NULL,
	FOREIGN KEY ("card") REFERENCES "credit_card" ("card"),
	FOREIGN KEY ("id_merchant") REFERENCES "merchant" ("id")
);
