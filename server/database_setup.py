import sys
import pymysql

from sqlalchemy import Column, ForeignKey, Integer, String

from sqlalchemy.ext.declarative import declarative_base

from sqlalchemy.orm import relationship

from sqlalchemy import create_engine


# declarative_base() : Table 생성을 위한 부모 class인 Base 생성하는 함수
Base = declarative_base()


class Summarized(Base):
    __tablename__ = 'summarized_news'

    


class QnA(Base):
    __tablename__ = 'qna_news'

    


##### insert at end of file #####

engine = create_engine('mysql+pymysql://root:root@localhost/news')

Base.metadata.create_all(engine)
