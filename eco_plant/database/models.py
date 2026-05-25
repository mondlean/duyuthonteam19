from sqlalchemy import Column, Integer, String
from database.database import Base

class UserPlant(Base):

    __tablename__ = "user_plants"

    id = Column(Integer, primary_key=True, index=True)

    nickname = Column(String)

    total_point = Column(Integer, default=0)

    plant_status = Column(String)